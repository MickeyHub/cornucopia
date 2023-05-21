//
//  HomeViewModel.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import Foundation

class HomeViewModel {
    
    private var plugins = [String: [Plugin]]()
    
    func observeInstaller(_ observer: @escaping ()->Void) {
        Installer.shared.observe { plugin, state in
            if case .success = state {
                observer()
            }
        }
    }
    
    func loadPlugins() {
        Installed.shared.load()
        plugins.removeAll()
        
        Installed.shared.plugins.forEach { plugin in
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
    }
    
    var numberOfSection: Int {
        return self.plugins.count
    }
    
    var isEmpty: Bool {
        self.plugins.isEmpty
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
}
