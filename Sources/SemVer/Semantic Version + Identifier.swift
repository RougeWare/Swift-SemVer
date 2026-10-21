//
//  Semantic Version + Identifier.swift
//  SemVer
//
//  Created by Ky on 2026-10-11.
//

import Foundation
import EssentiallyAString



/// A single piece of a semantic version, like `minor` or `build`
public struct SemanticVersionIdentifier<CharacterRestrictions: SemanticVersionIdentifierCharacterRestrictions> {
    
    /// This allows us to provide more compile-time guarantees about how identifiers are used
    private var _guts: _Guts
    
    fileprivate init(_guts: _Guts) {
        self._guts = _guts
    }
    
    
    internal init(unchecked text: String) {
        if let integer = UInt(text), integer.description == text {
            self.init(_guts: .integer(integer))
        }
        else {
            self.init(_guts: .string(text))
        }
    }
    
    
    
    fileprivate enum _Guts {
        case integer(DigitIdentifierRawValue)
        case string(StringIdentifierRawValue)
    }
    
    
    
    public typealias CharacterRestrictions = CharacterRestrictions
    
    // Would rather these types be derived if possible
    public typealias DigitIdentifierRawValue = UInt
    public typealias StringIdentifierRawValue = Swift.StringLiteralType
    
}



extension SemanticVersion.Identifier: CustomStringConvertible {
    
    public var description: String {
        switch self._guts {
        case .integer(let value):
            return value.description
            
        case .string(let value):
            return value
        }
    }
}



// MARK: - Type system


/// A marker protocol used in creating the compile-time guarantees for ``SemanticVersionIdentifier``'s felexibilities.
///
/// - Attention: DON'T use this directly. This is `public` for the compiler, but only for internal use.
public protocol SemanticVersionIdentifierCharacterRestrictions {}

/// Identifier characters are restricted to digits `[0-9]` (protocol style)
public protocol CanBeAnyDigit: SemanticVersionIdentifierCharacterRestrictions {}

/// Identifier characters are restricted to digits `[0-9]` (concrete type style)
public enum OnlyDigits: CanBeAnyDigit {}

/// Identifier characters are restricted to alphanumerics `[a-zA-Z0-9]` (protocol style)
public protocol CanBeAlphanumeric: CanBeAnyDigit {}

/// Identifier characters are restricted to alphanumerics `[a-zA-Z0-9]` (concrete type style)
public enum OnlyAlphanumerics: CanBeAlphanumeric {}



public extension SemanticVersion {
    typealias AnyIdentifier = Identifier<OnlyAlphanumerics>
}



// MARK: - Integer identifiers

extension SemanticVersion.Identifier: ExpressibleByIntegerLiteral
where Self.CharacterRestrictions: CanBeAnyDigit
{
    public typealias IntegerLiteralType = DigitIdentifierRawValue
    
    
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(_guts: .integer(value))
    }
    
    
    public init(_ value: DigitIdentifierRawValue) {
        self.init(_guts: .integer(value))
    }
    
    
    public static func integer(_ value: DigitIdentifierRawValue) -> Self {
        self.init(_guts: .integer(value))
    }
}



public extension SemanticVersion.Identifier where CharacterRestrictions == OnlyDigits {
    var integerValue: DigitIdentifierRawValue {
        switch self._guts {
        case .integer(let value):
            return value
            
        case .string(let value):
            if let intValue = DigitIdentifierRawValue(value) {
                return intValue
            }
            else {
                assertionFailure("`inteverValue` called on a non-digit string identifier which somehow declares its flexibility to be `OnlyDigits`")
                return .max
            }
        }
    }
    
    
    static func += (lhs: inout Self, rhs: DigitIdentifierRawValue) {
        switch lhs._guts {
        case .integer(var lhsInt):
            lhsInt += rhs
            lhs = .integer(lhsInt)
            
        case .string(let lhsString):
            if var lhsInt = DigitIdentifierRawValue(lhsString) {
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
    
    
    private static func areEqual_integers(lhs: DigitIdentifierRawValue, rhs: DigitIdentifierRawValue) -> Bool {
        lhs == rhs
    }
    
    
    private static func areEqual_strings(lhs: String, rhs: String) -> Bool {
        if let lhsInt = DigitIdentifierRawValue(lhs),
           let rhsInt = DigitIdentifierRawValue(rhs)
        {
            areEqual_integers(lhs: lhsInt, rhs: rhsInt)
        }
        else {
            lhs == rhs
        }
    }
}



extension SemanticVersion.Identifier: Comparable/*, ObjcComparable*/ {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs: lhs._guts, rhs: rhs._guts) {
        case (lhs: .integer(let lhsValue), rhs: .integer(let rhsValue)):
            lhsValue < rhsValue
        case (lhs: .string(let lhsValue), rhs: .string(let rhsValue)):
            lhsValue.utf8.lexicographicallyPrecedes(rhsValue.utf8)
        case (lhs: .integer, rhs: .string):
            true
        case (lhs: .string, rhs: .integer):
            false
        }
    }
    
    
//    public func compare(_ other: SemanticVersionIdentifier<CharacterRestrictions>) -> ComparisonResult {
//        if let self = self as? SemanticVersionIdentifier<OnlyDigits>,
//            let other = other as? SemanticVersionIdentifier<OnlyDigits> {
//            return self._compare_digits(other)
//        }
//        else if let self = self as? SemanticVersionIdentifier<OnlyAlphanumerics>,
//           let other = other as? SemanticVersionIdentifier<OnlyAlphanumerics> {
//            return self._compare_ascii(other)
//        }
//        else if let self = self as? SemanticVersionIdentifier<OnlyAlphanumerics>,
//           let other = other as? SemanticVersionIdentifier<OnlyDigits> {
//            return .orderedDescending
//        }
//        else if let self = self as? SemanticVersionIdentifier<OnlyDigits>,
//                let other = other as? SemanticVersionIdentifier<OnlyAlphanumerics> {
//            return .orderedAscending
//        }
//        else {
//            assertionFailure("Custom character restrictions aren't supported.")
//            return .orderedSame
//        }
//    }
//    
//    
//    private func _compare_digits(_ rhs: SemanticVersionIdentifier<OnlyDigits>) -> ComparisonResult
//        where Self.CharacterRestrictions == OnlyDigits
//    {
//        self.integerValue.compare(to: rhs.integerValue)
//    }
//    
//    
//    private func _compare_ascii(_ rhs: SemanticVersionIdentifier<OnlyAlphanumerics>) -> ComparisonResult
//        where Self.CharacterRestrictions == OnlyAlphanumerics
//    {
//        self.rawValue.compare(rhs.rawValue)
//    }
//    
//    
//    private static func areInAscendingOrder_integers(lhs: UInt, rhs: UInt) -> Bool {
//        lhs < rhs
//    }
//    
//    
//    private static func areInAscendingOrder_strings(lhs: String, rhs: String) -> Bool {
//        if let lhsInt = UInt(lhs),
//           let rhsInt = UInt(rhs)
//        {
//            areInAscendingOrder_integers(lhs: lhsInt, rhs: rhsInt)
//        }
//        else {
//            lhs < rhs
//        }
//    }
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
        if CharacterRestrictions.self is CanBeAlphanumeric {
            
        }
        do {
            self.init(_guts: .integer(try DigitIdentifierRawValue(from: decoder)))
        }
        catch {
            self.init(_guts: .string(try StringIdentifierRawValue(from: decoder)))
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



// MARK: - String identifiers

public extension SemanticVersion.Identifier
where Self.CharacterRestrictions: CanBeAlphanumeric
{
    static func string(_ value: StringIdentifierRawValue) -> Self {
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


where Self.CharacterRestrictions == OnlyAlphanumerics
{
    // upcoming EssentiallyAString patch fixes this:
//    public typealias StringLiteralType = StringIdentifierRawValue
//    public typealias ExtendedGraphemeClusterLiteralType = StringIdentifierRawValue
//    public typealias UnicodeScalarLiteralType = StringIdentifierRawValue
    
    
    public init(rawValue value: StringIdentifierRawValue) {
        self.init(unchecked: value)
    }
    
    
    public init(_ value: StringIdentifierRawValue) {
        self.init(_guts: .string(value))
    }
    
    
    public init(_ subsequence: SubSequence) {
        self.init(rawValue: .init(subsequence))
    }
    
    
    public var rawValue: StringIdentifierRawValue {
        get { description }
        
        @available(*, unavailable, message: "Identifiers are immutable")
        set {
            assertionFailure("Identifiers are immutable; tried to set rawValue of \(self) to \"\(newValue)\"")
        }
    }
}
