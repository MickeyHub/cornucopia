//
//  PluginCenterViewModel.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/18.
//

import Foundation
import UIKit

class GroceryViewModel {
    
    enum APIState {
        case loading
        case success
        case error(Error?)
    }
    
    private var plugins = [String: [Plugin]]()
    
    func loadPlugins(_ finished: @escaping (APIState)->Void) {
        
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                finished(.loading)
            }
            
            let req = URLRequest(url: URL(string: "https://raw.githubusercontent.com/MickeyHub/cornucopia_center/main/manifest.json")!)
            URLSession.shared.dataTask(with: req) { data, resp, error in
                
                if let error = error {
                    DispatchQueue.main.async {
                        finished(.error(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        finished(.error(nil))
                    }
                    return
                }
                
                self.plugins.removeAll()
                
                do {
                    let plugins = try JSONDecoder().decode([Plugin].self, from: data)
                    plugins.forEach { plugin in
                        if var subPlugins = self.plugins[plugin.category] {
                            subPlugins.append(plugin)
                            subPlugins.sort {
                                $0.displayName < $1.displayName
                            }
                            self.plugins[plugin.category] = subPlugins
                        } else {
                            self.plugins[plugin.category] = [plugin]
                        }
                    }
                    
                    DispatchQueue.main.async {
                        finished(.success)
                    }
                } catch {
                    DispatchQueue.main.async {
                        finished(.error(error))
                    }
                    return
                }
                
            }.resume()
        }
    }
    
    var numberOfSection: Int {
        return self.plugins.count
    }
    
    func section(at index: Int) -> String {
        let arr = Array(self.plugins.keys)
        return arr.sorted(by: <)[index]
    }
    
    func numberOfItems(for section: Int) -> Int {
        let category = self.section(at: section)
        return self.plugins[category]?.count ?? 0
    }
    
    func name(at indexPath: IndexPath) -> String {
        let category = self.section(at: indexPath.section)
        return self.plugins[category]?[indexPath.item].displayName ?? ""
    }
    
    func plugin(at indexPath: IndexPath) -> Plugin {
        let category = self.section(at: indexPath.section)
        return self.plugins[category]![indexPath.item]
    }
    
    func install(at indexPath: IndexPath) {
        let plugin = self.plugin(at: indexPath)
        Installer.shared.install(plugin)
    }
    
    func state(at indexPath: IndexPath) -> InstallButton.State {
        let plugin = self.plugin(at: indexPath)
        
        if Installer.shared.isInstalling(plugin) {
            let progress = Installer.shared.progress(of: plugin)
            return .downloading(progress)
        } else if Installed.shared.isInstalled(plugin) {
            
            let currentVersion = Installed.shared.version(of: plugin)
            
            if Version(currentVersion) < Version(plugin.version) {
                return .available(.update)
            } else {
                return .downloaded
            }
        } else {
            if Version(UIDevice.current.systemVersion) < Version(plugin.supportedIOSVersion) {
                return .unavailable(plugin.version)
            } else {
                return .available(.install)
            }
        }
    }
    
    func observeInstaller(_ handler: @escaping (IndexPath)->Void) {
        Installer.shared.observe { [weak self] plugin, state in
            guard let self = self else {
                return
            }
            guard let plugins = self.plugins[plugin.category] else {
                return
            }
            let keys = Array(self.plugins.keys).sorted(by: <)
            
            let section = keys.firstIndex(of: plugin.category)!
            let item = plugins.firstIndex(of: plugin)!
            
            let indexPath = IndexPath(item: item, section: section)
            handler(indexPath)
        }
    }
    
    func observeInstalled(_ handler: @escaping ()->Void) {
        Installed.shared.observeDeletionAction(handler)
    }
}
