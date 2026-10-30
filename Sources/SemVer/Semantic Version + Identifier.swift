//
//  Semantic Version + Identifier.swift
//  SemVer
//
//  Created by Ky on 2026-10-11.
//  Some code written by directing Claude Sonnet 5.5
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
    
    
    /// Creates an identifier from text which has previously satisfied `CharacterRestrictions`.
    ///
    /// Text which is a canonical number (`0`, or digits with no leading zero) becomes `.integer`; anything else becomes
    /// `.string` and is kept verbatim. Every initializer which takes text must go through this one, so that two
    /// identifiers are equal if and only if they have the same storage case and value.
    ///
    /// - Parameter preValidatedString: The string version of the identifier. If it can comfortably fit in an integer, then it's stored that way, else it's stored as a string. `nil` means the identifier was deemed invalid.
    internal init(_unchecked preValidatedString: String?) {
        guard let preValidatedString = preValidatedString?.nonEmptyOrNil else {
            self.init(_guts: ._invalidLiteral)
            return
        }
        
        if let integer = UInt(preValidatedString), integer.description == preValidatedString {
            self.init(_guts: .integer(integer))
        }
        else {
            self.init(_guts: .string(preValidatedString))
        }
    }
    
    
    /// If the given text is a valid identifier, then this initializes it. Else, it returns `nil`.
    ///
    /// Whether or not the identifier is valid, depends on the character restrictions of this identifier type.
    ///
    /// - Parameter text: The identifier as a raw string
    public init?(validating text: String) {
        guard let Grammar = (CharacterRestrictions.self as? any SemanticVersionIdentifierGrammar.Type),
              Grammar.isValid(text)
        else {
            return nil
        }
        
        self.init(_unchecked: text)
    }
    
    
    
    /// The in-memory storage of the identifier
    fileprivate enum _Guts {
        
        /// A valid integer identifier, like `4` or `2026`
        case integer(DigitIdentifierRawValue)
        
        /// A valid string identifier, like `"alpha"` or `"007"`
        case string(StringIdentifierRawValue)
        
        /// The dev attempted to specify invalid identifier (anything other than a valid identifier) as a Literal
        ///
        /// For example:
        /// ```swift
        /// let _: SemVer.PreRelease.Identifier = "🫪"
        /// ```
        case _invalidLiteral
    }
    
    
    
    public typealias CharacterRestrictions = CharacterRestrictions
    
    // Would rather these types be derived if possible
    public typealias DigitIdentifierRawValue = UInt
    public typealias StringIdentifierRawValue = Swift.StringLiteralType
}



internal extension SemanticVersion.Identifier {
    
    /// `true` iff this is a valid identifier
    ///
    /// Invalid identifiers are momentary signals that the dev attempted to create an identifier using Literal syntax which, but the identifier they tried to create would have been invalid. These should be removed as soon as possible, as their placeholder nature makes their inclusion in a semantic version necessarily out-of-spec
    var isValid: Bool {
        switch self._guts {
        case ._invalidLiteral:
            false
            
        case .integer,
                .string:
            true
        }
    }
}



extension SemanticVersion.Identifier: CustomStringConvertible {
    
    /// The string value of the SemVer identifier
    public var description: String {
        switch self._guts {
        case .integer(let value):
            return value.description
            
        case .string(let value):
            return value
            
        case ._invalidLiteral:
            return ""
        }
    }
}



// MARK: - Type system


/// A marker protocol used in creating the compile-time guarantees for ``SemanticVersionIdentifier``'s felexibilities.
///
/// - Attention: DON'T use this directly. This is `public` for the compiler, but only for internal use.
public protocol SemanticVersionIdentifierCharacterRestrictions {}

/// Not visible outside this module, so nobody else can implement or even name it. Every restriction this module accepts adopts it
internal protocol SemanticVersionIdentifierGrammar {
    
    /// Whether the given text is a legal identifier under this restriction
    static func isValid(_ candidate: String) -> Bool
}

/// Identifier characters are restricted to digits `[0-9]` (protocol style)
public protocol CanBeAnyDigit: SemanticVersionIdentifierCharacterRestrictions {}

/// Identifier characters are restricted to digits `[0-9]` (concrete type style)
///
/// This is the grammar's `<numeric identifier>`: `0`, or digits with no leading zero
public enum OnlyDigits: CanBeAnyDigit, SemanticVersionIdentifierGrammar {
    internal static func isValid(_ candidate: String) -> Bool { candidate.isNumericIdentifier }
}

/// Identifier characters are restricted to ASCII alphanumerics and hyphen `[a-zA-Z0-9-]` (protocol style)
public protocol CanBeAlphanumeric: CanBeAnyDigit {}

/// Identifier characters are restricted to ASCII alphanumerics and hyphen `[a-zA-Z0-9-]` (concrete type style)
///
/// This is anything which any extension could contain: the grammar's `<build identifier>`
public enum OnlyAlphanumerics: CanBeAlphanumeric, SemanticVersionIdentifierGrammar {
    internal static func isValid(_ candidate: String) -> Bool { candidate.isBuildIdentifier }
}

/// The grammar's `<pre-release identifier>`: like ``OnlyAlphanumerics``, except that all-digit identifiers must not have leading zeroes
public enum PreReleaseCharacters: CanBeAlphanumeric, SemanticVersionIdentifierGrammar {
    internal static func isValid(_ candidate: String) -> Bool { candidate.isPreReleaseIdentifier }
}

/// The grammar's `<build identifier>`: like ``OnlyAlphanumerics``, and all-digit identifiers may have leading zeroes
public enum BuildCharacters: CanBeAlphanumeric, SemanticVersionIdentifierGrammar {
    internal static func isValid(_ candidate: String) -> Bool { candidate.isBuildIdentifier }
}



private let `ascii_-` = UInt8(ascii: "-")
private let ascii_0   = UInt8(ascii: "0")
private let ascii_0_9 =           ascii_0...UInt8(ascii: "9")
private let ascii_A_Z = UInt8(ascii: "A")...UInt8(ascii: "Z")
private let ascii_a_z = UInt8(ascii: "a")...UInt8(ascii: "z")



fileprivate extension String {
    
    /// The grammar's `<digits>`
    var isOnlyDigits: Bool {
        false == isEmpty && utf8.allSatisfy { ascii_0_9.contains($0) }
    }
    
    
    /// A numeric identifier is either the digit `0`, or any all-digits string **WITHOUT** leading zeroes
    var isNumericIdentifier: Bool {
        isOnlyDigits && ("0" == self || ascii_0 != utf8.first)
    }
    
    
    /// A build identifier is one or more of `[0-9A-Za-z-]`
    var isBuildIdentifier: Bool {
        false == isEmpty
            && utf8.allSatisfy {
                    ascii_0_9.contains($0)
                ||  ascii_A_Z.contains($0)
                ||  ascii_a_z.contains($0)
                || `ascii_-` == $0
            }
    }
    
    
    /// The grammar's `<pre-release identifier>`: like a build identifier, except all-digit text must be a numeric identifier
    var isPreReleaseIdentifier: Bool {
        isBuildIdentifier && (false == isOnlyDigits || isNumericIdentifier)
    }
}



public extension SemanticVersion {
    typealias AnyIdentifier = Identifier<OnlyAlphanumerics>
}



public extension SemanticVersion.AnyIdentifier {

    /// Widens an identifier from any extension (or from major/minor/patch) so it can be compared with the others
    ///
    /// This can't fail: the text of an existing identifier is already in canonical form, and every restriction's identifiers are legal under ``OnlyAlphanumerics``
    ///
    /// - Parameter other: The identifier to widen
    init?<Other: SemanticVersionIdentifierCharacterRestrictions>(_ other: SemanticVersion.Identifier<Other>) {
        self.init(validating: other.description)
    }
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
                assertionFailure("""
                    PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                    `integerValue` called on a non-digit string identifier which somehow declares its flexibility to be `OnlyDigits`
                    """)
                return .max
            }
            
        case ._invalidLiteral:
            assertionFailure("""
                PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                `integerValue` called on an invalid identifier which somehow declares its flexibility to be `OnlyDigits`
                """)
            return .max
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
                assertionFailure("""
                    PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                    `+=` called on a non-digit string identifier which somehow declares its flexibility to be `OnlyDigits`
                    """)
            }
            
        case ._invalidLiteral:
            assertionFailure("""
                PACKAGE MAINTAINER ERROR: Report this to https://github.com/RougeWare/Swift-SemVer/issues
                `+=` called on an invalid identifier which somehow declares its flexibility to be `OnlyDigits`
                """)
        }
    }
}



extension SemanticVersion.Identifier: Equatable {
    
    /// Compares equality between two SemVer identifiers.
    ///
    /// Only identical identifiers are considered equal. For example, `007 != 7`.
    /// For more about equality in semantic versions, see https://semver.org/spec/v2.0.0.html
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs: lhs._guts, rhs: rhs._guts) {
        case (lhs: .integer(let lhsValue), rhs: .integer(let rhsValue)):
            lhsValue == rhsValue
            
        case (lhs: .string(let lhsValue), rhs: .string(let rhsValue)):
            // assume that the initial parsing did its job and stored integers in `.integer(_:)`
            lhsValue == rhsValue
            
        // Canonical-form numbers are always stored as integers, so an integer never equals a string
        case (lhs: .integer, rhs: .string),
             (lhs: .string, rhs: .integer):
            false
            
        // Invalid identifiers are momentary and should never appear in the wild.
        // If they do, then like NaN they never equal anything
        case (lhs: ._invalidLiteral, rhs: _),
             (lhs: _, rhs: ._invalidLiteral):
            false
        }
    }
}



extension SemanticVersion.Identifier: Comparable {

    /// Implements the identifier rules of SemVer 2.0.0 item 11: https://semver.org/spec/v2.0.0.html#spec-item-11
    ///
    /// - Numeric identifiers are compared numerically
    /// - Other identifiers are compared lexically in ASCII order
    /// - Numeric identifiers always have lower precedence than other identifiers
    public static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs: lhs._guts, rhs: rhs._guts) {
        case (lhs: .integer(let lhsValue), rhs: .integer(let rhsValue)):
            lhsValue < rhsValue
            
        case (lhs: .string(let lhsValue), rhs: .string(let rhsValue)):
            // A numeric identifier too big for `UInt` is stored as a string, but still sorts as a number
            switch (lhsIsNumeric: lhsValue.isNumericIdentifier, rhsIsNumeric: rhsValue.isNumericIdentifier) {
                // `isNumericIdentifier` excludes leading zeroes
            case (lhsIsNumeric: true, rhsIsNumeric: true):
                lhsValue.utf8.count == rhsValue.utf8.count
                    ? lhsValue.utf8.lexicographicallyPrecedes(rhsValue.utf8)
                    : lhsValue.utf8.count < rhsValue.utf8.count
                
            case (lhsIsNumeric: true, rhsIsNumeric: false):
                true
                
            case (lhsIsNumeric: false, rhsIsNumeric: true):
                false
                
            case (lhsIsNumeric: false, rhsIsNumeric: false):
                lhsValue.utf8.lexicographicallyPrecedes(rhsValue.utf8)
            }
            
        case (lhs: .integer, rhs: .string):
            true
            
        case (lhs: .string, rhs: .integer):
            false
            
        // Invalid identifiers are momentary and should never appear in the wild.
        // If they do, then like NaN they never sort predictably
        case (lhs: ._invalidLiteral, rhs: _),
            (lhs: _, rhs: ._invalidLiteral):
            false
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
            
        case ._invalidLiteral:
            hasher.combine(Float.nan) // treat invalid identifiers as NaN
        }
    }
}



extension SemanticVersion.Identifier: Decodable {
    public init(from decoder: any Decoder) throws {
        let candidate: String
        do {
            candidate = try DigitIdentifierRawValue(from: decoder).description
        }
        catch {
            candidate = try StringIdentifierRawValue(from: decoder)
        }

        guard (CharacterRestrictions.self as? any SemanticVersionIdentifierGrammar.Type)?.isValid(candidate) ?? false else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: decoder.codingPath,
                debugDescription: "\"\(candidate)\" is not a valid identifier for \(CharacterRestrictions.self)"))
        }

        self.init(_unchecked: candidate)
    }
}



extension SemanticVersion.Identifier: Encodable {
    public func encode(to encoder: any Encoder) throws {
        switch self._guts {
        case .integer(let uInt):
            try uInt.encode(to: encoder)
            
        case .string(let stringLiteralType):
            try stringLiteralType.encode(to: encoder)
            
        case ._invalidLiteral:
            // Don't touch the encoder at all
            break
        }
    }
}



// MARK: - String identifiers

public extension SemanticVersion.Identifier
where Self.CharacterRestrictions: CanBeAlphanumeric
{
    /// A string identifier
    ///
    /// This creates a new identifier using the given string. This performs validation and only returns an identifier if it's valid
    ///
    /// - Parameter value: The value of the identifier
    /// - Returns: A new identifier holding the given value, or `nil` if it isn't valid
    static func string(_ value: StringIdentifierRawValue) -> Self? {
        self.init(validating: value)
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


where Self.CharacterRestrictions: CanBeAlphanumeric
{
    public init(rawValue value: StringIdentifierRawValue) {
        guard let newSelf = Self.init(validating: value) else {
            assertionFailure("\"\(value)\" is not a valid identifier for \(CharacterRestrictions.self)")
            self.init(_unchecked: nil)
            return
        }
        
        self = newSelf
    }


    public init(_ value: StringIdentifierRawValue) {
        self.init(rawValue: value)
    }
    
    
    public init(_ subsequence: SubSequence) {
        self.init(rawValue: .init(subsequence))
    }
    
    
    public var rawValue: StringIdentifierRawValue {
        get { description }
        
        @available(*, unavailable, message: "Identifiers are immutable")
        set {
            assertionFailure("Identifiers are immutable; refusing to set `rawValue` of self (\(self)) to \"\(newValue)\"")
        }
    }
}
