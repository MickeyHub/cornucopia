//
//  Installed.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import Foundation

class Installed {
    
    private(set) var plugins = [Plugin]()
    
    private init() {}
    
    static let shared = Installed()
    
    private var deletionObserver: (()->Void)?
    
    func observeDeletionAction(_ handler: @escaping ()->Void) {
        deletionObserver = handler
    }
    
    func load() {
        
        let root = Plugin.root
        guard FileManager.default.fileExists(atPath: root) else {
            return
        }
        guard let frameworks = try? FileManager.default.contentsOfDirectory(atPath: root) else {
            return
        }
        
        plugins.removeAll()
        
        frameworks.forEach { framework in
            let plist = "file://\(root)/\(framework)/Cornucopia.plist"
            if let data = try? Data(contentsOf: URL(string: plist)!) {
                do {
                    let plugin = try PropertyListDecoder().decode(Plugin.self, from: data)
                    plugins.append(plugin)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func isInstalled(_ plugin: Plugin) -> Bool {
        plugins.contains(plugin)
    }
    
    func version(of plugin: Plugin) -> String {
        guard let p = plugins.first(where: { $0.displayName == plugin.displayName }) else {
            fatalError()
        }
        return p.version
    }
    
    func delete(_ plugin: Plugin) {
        try? FileManager.default.removeItem(atPath: plugin.pluginLocation)
        try? FileManager.default.removeItem(atPath: plugin.documentLocation)
        try? FileManager.default.removeItem(atPath: plugin.cacheLocation)
        try? FileManager.default.removeItem(atPath: plugin.preferenceLocation)
        
        load()
        deletionObserver?()
    }
}
