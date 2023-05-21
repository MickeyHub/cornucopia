//
//  Downloader.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/18.
//

import Foundation

class Installer {
    
    enum State {
        case installing (Double)
        case success
        case error
    }
    
    /// hold handlers for callback
    typealias StateHandler = (Plugin, State)->Void
    private var handlers = [StateHandler]()
    
    /// hold plugins downloading for reentry
    private var plugins = [Plugin]()
    
    /// hold the last progress for fetching initiative
    private var progresses = [Plugin: Double]()
    
    /// singleton
    private init() {}
    static let shared = Installer()
    
    func install(_ plugin: Plugin) {
        
        if plugins.contains(plugin) {
            if let progress = progresses[plugin] {
                notify(plugin, .installing(progress))
            }
            return
        }
        
        self.plugins.append(plugin)
        
        let task = PluginDownload(plugin)
        task.onStarted = { [weak self] in
            guard let self = self else { return }
            
            self.notify(plugin, .installing(0))
        }
        task.onReceived = { [weak self] received, total in
            guard let self = self else { return }

            let percent = Double(received) / Double(total)
            self.notify(plugin, .installing(percent))
        }
        task.onFinished = { [weak self] error in
            guard let self = self else { return }
            
            self.plugins.removeAll { p in
                plugin.displayName == p.displayName
            }
            
            if let _ = error {
                self.notify(plugin, .error)
            } else {
                Installed.shared.load()
                self.notify(plugin, .success)
            }
        }
        task.resume()
    }
    
    func progress(of plugin: Plugin) -> Double {
        progresses[plugin] ?? 0
    }
    
    func isInstalling(_ plugin: Plugin) -> Bool {
        plugins.contains(plugin)
    }
    
    func observe(_ handler: @escaping StateHandler) {
        handlers.append(handler)
    }
    
    private func notify(_ plugin: Plugin, _ state: State) {
        
        if case .installing(let double) = state {
            progresses[plugin] = double
        } else {
            progresses[plugin] = nil
        }
        
        handlers.forEach { handler in
            handler(plugin, state)
        }
    }
}
