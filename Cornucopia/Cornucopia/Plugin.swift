//
//  Plugin.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/18.
//

import Foundation

struct Plugin {
    
    var displayName: String
    var description: String
    var icon: String
    
    var author: String
    var releaseDate: String
    var mail: String
    var homepage: String
    var category: String
    
    var version: String
    var supportedIOSVersion: String
    
    var entry: String
    var framework: String
    var executable: String
}

extension Plugin: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.displayName)
    }
}

extension Plugin: Equatable {
    static func == (lhs: Plugin, rhs: Plugin) -> Bool {
        lhs.displayName == rhs.displayName
    }
}

extension Plugin: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case description
        case icon
        case author
        case releaseDate = "release_date"
        case mail
        case homepage
        case category
        case version
        case supportedIOSVersion = "supported_ios_version"
        case entry
        case framework
        case executable
    }
}

extension Plugin {
    
    static var root: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/plugins/"
    }
    
    var pluginLocation: String {
        Plugin.root + framework
    }
    
    var executablePath: String {
        pluginLocation + "/" + executable
    }
    
    var temperatoryPath: String {
        let path = FileManager.default.temporaryDirectory.absoluteString + framework + ".zip"
        return String(path[path.index(path.startIndex, offsetBy: 7)...])
    }
    
    var documentLocation: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + framework
    }
    
    var cacheLocation: String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/" + framework
    }
    
    var preferenceLocation: String {
        NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first! + "/Preferences/" + framework + ".plist"
    }
}
