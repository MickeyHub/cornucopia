//
//  PluginDownload.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import Foundation

class PluginDownload {
    
    let plugin: Plugin
    
    var onStarted: (() -> Void)?
    
    var onReceived: ((Int64, Int64) -> Void)?
    
    var onFinished: ((Error?) -> Void)?
    
    init(_ plugin: Plugin) {
        self.plugin = plugin
    }
    
    func resume() {
        Downloader.shared.download(self)
    }
}
