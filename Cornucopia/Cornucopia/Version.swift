//
//  Version.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import Foundation

struct Version {
    
    let version: String
    
    init(_ version: String) {
        self.version = version
    }
}

extension Version: Equatable {
    static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.version == rhs.version
    }
}

extension Version: Comparable {
    static func < (lhs: Version, rhs: Version) -> Bool {
        
        var leftSegments = lhs.version.components(separatedBy: ".")
        var rightSegments = rhs.version.components(separatedBy: ".")
        
        var left = lhs.version
        if leftSegments.count != 3 {
            left = leftSegments.count == 1 ? lhs.version + ".0.0" : lhs.version + ".0"
        }
        var right = rhs.version
        if rightSegments.count != 3 {
            right = rightSegments.count == 1 ? rhs.version + ".0.0" : rhs.version + ".0"
        }
        
        leftSegments = left.components(separatedBy: ".")
        rightSegments = right.components(separatedBy: ".")
        
        for i in 0..<3 {
            if Int(leftSegments[i])! > Int(rightSegments[i])! {
                return false
            } else if Int(leftSegments[i])! < Int(rightSegments[i])! {
                return  true
            }
        }
        return false
    }

    static func <= (lhs: Version, rhs: Version) -> Bool {
        lhs < rhs || lhs == rhs
    }

    static func >= (lhs: Version, rhs: Version) -> Bool {
        lhs > rhs || lhs == rhs
    }

    static func > (lhs: Version, rhs: Version) -> Bool {
        !(lhs <= rhs)
    }
}
