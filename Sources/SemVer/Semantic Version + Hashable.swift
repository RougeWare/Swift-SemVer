//
//  Semantic Version + Hashable.swift
//  SemVer
//
//  Created by Ben Leggiero on 2020-04-19.
//  Copyright © 2020 Ben Leggiero BH-1-PS.
//

import Foundation



extension SemanticVersion: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        if let preRelease = preRelease {
            hasher.combine(preRelease)
        }
    }
}



extension SemanticVersion.PreRelease: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.identifiers.forEach {
            hasher.combine($0)
        }
    }
}
