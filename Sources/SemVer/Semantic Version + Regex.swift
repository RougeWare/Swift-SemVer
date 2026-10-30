//
//  Semantic Version + Regex.swift
//  SemVer
//
//  Created by Ky on 2026-10-29.
//

import Foundation
import RegexBuilder



public extension SemanticVersion {
    
    /// This namespace contains various regular expression pieces which you can use to validate a semantic version.
    ///
    /// The regular expressions in this namespace attempt to perfectly replicate the SemVer 2.0.0 BNF grammar:
    /// https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
    ///
    /// If you want to just validate the whole semantic version, use `SemVer.regex`
    enum Regex {}
}



public extension SemanticVersion.Regex {
    
    /// This namespace contains the names of capture groups that you can use in parsing the output of the regular expressions in ``Regex``.
    enum Captures {}
}



public extension SemanticVersion.Regex {
    static let validSemver = Regex {
        versionCore
        
        Optionally {
            "-"
            OptionalCapture(as: Captures.preRelease) {
                dotSeparatedPreReleaseIdentifiers
            }
        }
        
        Optionally {
            "+"
            OptionalCapture(as: Captures.build) {
                dotSeparatedBuildIdentifiers
            }
        }
    }
    
    
    static let versionCore = Regex {
        Capture(as: Captures.major) {
            major
        }
        
        "."
        
        Capture(as: Captures.minor) {
            minor
        }
        
        "."
        
        Capture(as: Captures.patch) {
            patch
        }
    }
    
    static let major = numericIdentifier
    static let minor = numericIdentifier
    static let patch = numericIdentifier
    
    static let preRelease = dotSeparatedPreReleaseIdentifiers
    
    static let dotSeparatedPreReleaseIdentifiers = Regex {
        preReleaseIdentifier
        
        ZeroOrMore {
            "."
            preReleaseIdentifier
        }
    }
    
    static let build = dotSeparatedBuildIdentifiers
    
    static let dotSeparatedBuildIdentifiers = Regex {
        buildIdentifier
        
        ZeroOrMore {
            "."
            buildIdentifier
        }
    }
    
    static let preReleaseIdentifier = Regex {
        ChoiceOf {
            alphanumericIdentifier
            numericIdentifier
        }
    }
    
    static let buildIdentifier = Regex {
        ChoiceOf {
            alphanumericIdentifier
            digits
        }
    }
    
    static let alphanumericIdentifier = Regex {
        ChoiceOf {
            nonDigit
            
            Local {
                nonDigit
                identifierCharacters
            }
            
            Local {
                identifierCharacters
                nonDigit
            }
            
            Local {
                identifierCharacters
                nonDigit
                identifierCharacters
            }
        }
    }
    
    static let numericIdentifier = Regex {
        ChoiceOf {
            "0"
            Local {
                positiveDigit
                ZeroOrMore { digits }
            }
        }
    }
    
    static let identifierCharacters = Regex {
        OneOrMore { identifierCharacter }
    }
    
    static let identifierCharacter = Regex {
        ChoiceOf {
            digit
            nonDigit
        }
    }
    
    static let nonDigit = Regex {
        ChoiceOf {
            letter
            "-"
        }
    }
    
    static let digits = Regex {
        OneOrMore { digit }
    }
    
    static let digit = Regex {
        ChoiceOf {
            "0"
            positiveDigit
        }
    }
    
    static let positiveDigit = Regex {
        "1"..."9"
    }
    
    static let letter = Regex {
        ChoiceOf {
            "A"..."Z"
            "a"..."z"
        }
    }
}



public extension SemanticVersion {
    /// A regular expression which matches and conveniently groups all Semantic Version strings.
    ///
    /// When you're using this to validate whether or not a string is a SemVer, remember to use `wholeMatch(in:)`.
    /// When you're using this to find a SemVer in a larger string, use `firstMatch(in:)` or `matches(of:)`.
    ///
    /// - Attention: To find a valid semver in a larger string, the SemVer **must** be isolated by word boundaries on either side. `v1.0.0` won't match this regex, nor will `27.2.0b`. Same goes for SemVer-looking version conventions: `8.2.4133.94` also won't match this regex. **However!** Punctuation after the SemVer is allowed: `Today we released version 2.0.0.` will match this regex, matching `2.0.0` and nothing else.
    ///              Of course, this will also not match an incomplete SemVer like `4.2.0-` or `0.6.7+`
    static let regex = Swift.Regex {
        SemVerStartBoundary()
        
        Regex.validSemver
        
        // The negative lookahead which prevents matching SemVer-style things that aren't valid SemVers, like `1.2.3b`,
        // While still allowing trailing punctuation, like `Upgrade to 3.1.2.`.
        //
        //  Don't match the following pattern
        //  │                Period followed by Unicode alphanumeric or hyphen
        // ┌┤                ├─────────────┐
        #/(?![\p{L}\p{N}_+-]|\.[\p{L}\p{N}-])/#
        //   ├─────────────┘
        //   Unicode alphanumeric, underscore, plus, or hyphen
    }
}



// MARK: - Captures

public extension SemanticVersion.Regex.Captures {
    static let major = Reference(Substring.self)
    static let minor = Reference(Substring.self)
    static let patch = Reference(Substring.self)
    static let preRelease = Reference(Substring?.self)
    static let preRelease_standalone = Reference(Substring.self)
    static let build = Reference(Substring?.self)
    static let build_standalone = Reference(Substring.self)
}



// MARK: - Shims

/// Implements SemVer-specific look-behind for Swift `Regex`.
///
/// Iff the character before this isn't alphanumeric, `_`, or `.` (or there is no character before this), then this matches without consuming.
private struct SemVerStartBoundary: CustomConsumingRegexComponent {
    typealias RegexOutput = Void
    
    func consuming(
        _ input: String,
        startingAt index: String.Index,
        in bounds: Range<String.Index>
    ) throws -> (upperBound: String.Index, output: Void)? {
        guard input.startIndex < index else {
            return (index, ())
        }
        
        let before = input[input.index(before: index)]
        
        if before.isLetter || before.isNumber || "_" == before || "." == before {
            return nil
        }
        else {
            return (index, ())
        }
    }
}



/// Sugar for making a named capture group return an optional output
///
/// For example, in the regex `/MacBook(?<kind> (Air|Pro|Neo))?/`, you would represent the optional Air/Pro/Neo part with this:
/// ```swift
/// let kind = Reference(Substring?.self)
/// Regex {
///     "MacBook"
///     OptionalCapture(as: kind) {
///         " "
///         ChoiceOf {
///             "Air"
///             "Pro"
///             "Neo"
///         }
///     }
/// }
/// ```
///
/// which then makes the matches optional:
///
/// ```swift
/// guard let match = macBookNameRegex.wholeMatch(in: inputString) else { return }
///
/// print("It's a MacBook!")
///
/// if let kind = match[kind] {
///     print("Specifically, the \(kind) variant")
/// }
/// ```
///
/// - Parameters:
///   - reference:        The "name" of the capture group
///   - componentBuilder: Standard `RegexBuilder` component builder. Put regex shit in here
internal func OptionalCapture<NewCapture, RC>(
    as reference: Reference<NewCapture?>,
    @RegexComponentBuilder _ componentBuilder: () -> RC,
) -> TryCapture<(Substring, NewCapture?)>
where RC: RegexComponent,
      RC.RegexOutput == NewCapture
{
    TryCapture(as: reference, componentBuilder) {
        Optional($0)
    }
}



// MARK: - Retroactive conformance

// Genuinely sorry if this causes compiler conflicts. Hoping the Swiftlang org improves Regex concurrency soon
extension Regex: @retroactive @unchecked Sendable where Output: Sendable {}
extension Reference: @retroactive @unchecked Sendable where Capture: Sendable {}



// MARK: - BNF

/* These were based on the official BNF of SemVer 2.0.0:

<valid semver> ::= <version core>
                 | <version core> "-" <pre-release>
                 | <version core> "+" <build>
                 | <version core> "-" <pre-release> "+" <build>

<version core> ::= <major> "." <minor> "." <patch>

<major> ::= <numeric identifier>

<minor> ::= <numeric identifier>

<patch> ::= <numeric identifier>

<pre-release> ::= <dot-separated pre-release identifiers>

<dot-separated pre-release identifiers> ::= <pre-release identifier>
                                          | <pre-release identifier> "." <dot-separated pre-release identifiers>

<build> ::= <dot-separated build identifiers>

<dot-separated build identifiers> ::= <build identifier>
                                    | <build identifier> "." <dot-separated build identifiers>

<pre-release identifier> ::= <alphanumeric identifier>
                           | <numeric identifier>

<build identifier> ::= <alphanumeric identifier>
                     | <digits>

<alphanumeric identifier> ::= <non-digit>
                            | <non-digit> <identifier characters>
                            | <identifier characters> <non-digit>
                            | <identifier characters> <non-digit> <identifier characters>

<numeric identifier> ::= "0"
                       | <positive digit>
                       | <positive digit> <digits>

<identifier characters> ::= <identifier character>
                          | <identifier character> <identifier characters>

<identifier character> ::= <digit>
                         | <non-digit>

<non-digit> ::= <letter>
              | "-"

<digits> ::= <digit>
           | <digit> <digits>

<digit> ::= "0"
          | <positive digit>

<positive digit> ::= "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

<letter> ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J"
           | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T"
           | "U" | "V" | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d"
           | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" | "n"
           | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x"
           | "y" | "z"

*/
