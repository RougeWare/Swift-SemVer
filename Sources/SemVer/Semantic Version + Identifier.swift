//
//  Semantic Version + Identifier.swift
//  SemVer
//
//  Created by Ky on 2026-10-11.
//

import Foundation
import EssentiallyAString



/// A single piece of a semantic version, like `minor` or `build`
public struct SemanticVersionIdentifier<Flexibility: SemanticVersionIdentifierCharacterRestrictions> {
    
    /// This allows us to provide more compile-time guarantees about how identifiers are used
    private var _guts: _Guts
    
    
    
    private enum _Guts {
        case integer(UInt)                   // Would rather these types be derived if possible
        case string(Swift.StringLiteralType) // Would rather these types be derived if possible
    }
    
    
    
    public typealias Flexibility = Flexibility
}



extension SemanticVersion.Identifier: CustomStringConvertible {
    
    public var description: String {
        switch self._guts {
        case .integer(let value as CustomStringConvertible),
                .string(let value as CustomStringConvertible):
            return value.description
        }
    }
}



// MARK: - Type system


/// A marker protocol used in creating the compile-time guarantees for ``SemanticVersionIdentifier``'s felexibilities
public protocol SemanticVersionIdentifierCharacterRestrictions {}
public protocol CanBeAnyDigit: SemanticVersionIdentifierCharacterRestrictions {}
public enum OnlyDigits: CanBeAnyDigit {}
public protocol CanBeAscii: CanBeAnyDigit {}
public enum OnlyAscii: CanBeAscii {}



public extension SemanticVersion {
    typealias AnyIdentifier = Identifier<OnlyAscii>
}



// MARK: Integer identifiers

extension SemanticVersion.Identifier: ExpressibleByIntegerLiteral
where Self.Flexibility: CanBeAnyDigit
{
    public typealias IntegerLiteralType = UInt
    
    
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(_guts: .integer(value))
    }
    
    
    public init(_ value: UInt) {
        self.init(_guts: .integer(value))
    }
    
    
    public static func integer(_ value: UInt) -> Self {
        self.init(_guts: .integer(value))
    }
}



public extension SemanticVersion.Identifier where Flexibility == OnlyDigits {
    var integerValue: UInt {
        switch self._guts {
        case .integer(let value):
            return value
            
        case .string(let value):
            if let intValue = UInt(value) {
                return intValue
            }
            else {
                assertionFailure("`inteverValue` called on a non-digit string identifier which somehow declares its flexibility to be `OnlyDigits`")
                return .max
            }
        }
    }
    
    
    static func += (lhs: inout Self, rhs: UInt) {
        switch lhs._guts {
        case .integer(var lhsInt):
            lhsInt += rhs
            lhs = .integer(lhsInt)
            
        case .string(let lhsString):
            if var lhsInt = UInt(lhsString) {
                lhsInt += rhs
                lhs = .integer(lhsInt)
            }
            else {
                assertionFailure("`+=` called on a non-digit string identifier which somehow declares its flexibility to be `OnlyDigits`")
            }
        }
    }
}



extension SemanticVersion.Identifier: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs: lhs._guts, rhs: rhs._guts) {
        case (lhs: .integer(let lhsValue), rhs: .integer(let rhsValue)):
            areEqual_integers(lhs: lhsValue, rhs: rhsValue)
            
        case (lhs: .string(let lhsValue), rhs: .string(let rhsValue)):
            areEqual_strings(lhs: lhsValue, rhs: rhsValue)
            
        case (lhs: .integer(let lhsValue), rhs: .string(let rhsValue)):
            areEqual_strings(lhs: lhsValue.description, rhs: rhsValue)
            
        case (lhs: .string(let lhsValue), rhs: .integer(let rhsValue)):
            areEqual_strings(lhs: lhsValue, rhs: rhsValue.description)
        }
    }
    
    
    private static func areEqual_integers(lhs: UInt, rhs: UInt) -> Bool {
        lhs == rhs
    }
    
    
    private static func areEqual_strings(lhs: String, rhs: String) -> Bool {
        if let lhsInt = UInt(lhs),
           let rhsInt = UInt(rhs)
        {
            areEqual_integers(lhs: lhsInt, rhs: rhsInt)
        }
        else {
            lhs == rhs
        }
    }
}



extension SemanticVersion.Identifier: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs: lhs._guts, rhs: rhs._guts) {
        case (lhs: .integer(let lhsValue), rhs: .integer(let rhsValue)):
            areInAscendingOrder_integers(lhs: lhsValue, rhs: rhsValue)
            
        case (lhs: .string(let lhsValue), rhs: .string(let rhsValue)):
            areInAscendingOrder_strings(lhs: lhsValue, rhs: rhsValue)
            
        case (lhs: .integer(let lhsValue), rhs: .string(let rhsValue)):
            areInAscendingOrder_strings(lhs: lhsValue.description, rhs: rhsValue)
            
        case (lhs: .string(let lhsValue), rhs: .integer(let rhsValue)):
            areInAscendingOrder_strings(lhs: lhsValue, rhs: rhsValue.description)
        }
    }
    
    
    private static func areInAscendingOrder_integers(lhs: UInt, rhs: UInt) -> Bool {
        lhs < rhs
    }
    
    
    private static func areInAscendingOrder_strings(lhs: String, rhs: String) -> Bool {
        if let lhsInt = UInt(lhs),
           let rhsInt = UInt(rhs)
        {
            areInAscendingOrder_integers(lhs: lhsInt, rhs: rhsInt)
        }
        else {
            lhs < rhs
        }
    }
}



extension SemanticVersion.Identifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self._guts {
        case .integer(let uInt):
            uInt.hash(into: &hasher)
            
        case .string(let stringLiteralType):
            stringLiteralType.hash(into: &hasher)
        }
    }
}



extension SemanticVersion.Identifier: Decodable {
    public init(from decoder: any Decoder) throws {
        do {
            self.init(_guts: .integer(try UInt(from: decoder)))
        }
        catch {
            self.init(_guts: .string(try String(from: decoder)))
        }
    }
}



extension SemanticVersion.Identifier: Encodable {
    public func encode(to encoder: any Encoder) throws {
        switch self._guts {
        case .integer(let uInt):
            try uInt.encode(to: encoder)
            
        case .string(let stringLiteralType):
            try stringLiteralType.encode(to: encoder)
        }
    }
}



// MARK: String identifiers

public extension SemanticVersion.Identifier
where Self.Flexibility: CanBeAscii
{
    static func string(_ value: String) -> Self {
        self.init(_guts: .string(value))
    }
}


extension SemanticVersion.Identifier:
    EssentiallyAString,
        StringProtocol,
        BidirectionalCollection,
        Collection,
        Sequence,
        ExpressibleByStringInterpolation,
        ExpressibleByStringLiteral,
            ExpressibleByExtendedGraphemeClusterLiteral,
                ExpressibleByUnicodeScalarLiteral,
        LosslessStringConvertible,
        TextOutputStream,
        TextOutputStreamable,
    MutableRawRepresentable,
        RawRepresentable


where Self.Flexibility == OnlyAscii
{
    
    public init(rawValue value: String) {
        if let integer = UInt(value) {
            self.init(_guts: .integer(integer))
        }
        else {
            self.init(_guts: .string(value))
        }
    }
    
    
    public init(_ value: String) {
        self.init(_guts: .string(value))
    }
    
    
    public init(_ subsequence: SubSequence) {
        self.init(rawValue: .init(subsequence))
    }
    
    
    public var rawValue: String {
        get { description }
        set { self = .init(rawValue: newValue) }
    }
}

