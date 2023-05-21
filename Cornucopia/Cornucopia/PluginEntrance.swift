//
//  PluginEntrance.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import UIKit

class PluginEntrance {
    
    private var plugins = [Plugin: UnsafeMutableRawPointer]()
    
    private init() {}
    
    static let shared = PluginEntrance()
    
    @discardableResult
    func navigate(_ plugin: Plugin) -> Bool {
        
        let executablePath = plugin.executablePath
        if !FileManager.default.fileExists(atPath: executablePath) {
            return false
        }
        
        if let handle = plugins[plugin] {
            if let opened = Array(plugins.keys).first(where: { $0.displayName == plugin.displayName } ) {
                if plugin.version != opened.version {
                    dlclose(handle)
                    let handle = dlopen(executablePath, RTLD_NOW | RTLD_GLOBAL)
                    plugins[opened] = nil
                    plugins[plugin] = handle
                }
            }
        } else {
            let handle = dlopen(executablePath, RTLD_NOW | RTLD_GLOBAL)
            plugins[plugin] = handle
        }
        
        guard let entry = NSClassFromString(plugin.entry) as? UIViewController.Type else {
            return false
        }
        let controller = entry.init()
        guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            return false
        }
        guard let navigator = tabBarController.selectedViewController as? UINavigationController else {
            return false
        }
        controller.hidesBottomBarWhenPushed = true
        navigator.pushViewController(controller, animated: true)
        return true
    }
}
