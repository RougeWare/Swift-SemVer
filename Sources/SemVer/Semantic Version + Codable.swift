//
//  Semantic Version + Codable.swift
//  SemVer
//
//  Created by Ky Leggiero on 2021-10-18.
//  Copyright © 2021 Ben "Ky" Leggiero BH-1-PS.
//

import Foundation



extension SemVer: Encodable {
    
    /// Encodes this semantic version to the given container
    /// - Throws any error which occurs when encoding
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}



extension SemVer: Decodable {
    
    /// Decodes a semantic version from its encoded form
    /// - Throws any error which occurs when decoding, including a `SemVer.DecodingError` if that's specialized to Semantic Version decoding
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        
        guard let parsed = Self.init(raw) else {
            throw DecodingError.invalidSemanticVersion(encodedForm: raw)
        }
        
        self = parsed
    }
    
    
    
    /// An error that migth occur when decoding a semantic version
    enum DecodingError: Error {
        
        /// The encoded form of the semantic version was an invalid semantic version
        case invalidSemanticVersion(encodedForm: String)
    }
}
