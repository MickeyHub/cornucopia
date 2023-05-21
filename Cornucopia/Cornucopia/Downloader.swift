//
//  Downloader.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/19.
//

import Foundation
import Zip

class Downloader : NSObject {
    
    private var downloads = [URLSessionDataTask: PluginDownload]()
    private var files = [URLSessionDataTask: FileHandle]()
    
    static let shared = Downloader()
    private var session: URLSession!
    
    private override init() {
        super.init()
        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
    }
}

extension Downloader {
    
    func download(_ download: PluginDownload) {
        
        let url = URL(string: "https://raw.githubusercontent.com/MickeyHub/cornucopia_center/main/plugins/\(download.plugin.framework).zip")!
        let req = URLRequest(url: url)
        let dataTask = self.session.dataTask(with: req)
        
        downloads[dataTask] = download
        
        dataTask.resume()
        download.onStarted?()
    }
}

extension Downloader : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let download = downloads[dataTask] else {
            return
        }
        
        if files[dataTask] == nil {
            let targetLocation = download.plugin.temperatoryPath
            FileManager.default.createFile(atPath: targetLocation, contents: nil)
            let handle = FileHandle(forUpdatingAtPath: targetLocation)
            files[dataTask] = handle
        }
        
        let handle = files[dataTask]!
        handle.write(data)
        
        DispatchQueue.main.async {
            if (dataTask.countOfBytesClientExpectsToReceive > 0) {
                download.onReceived?(dataTask.countOfBytesReceived, dataTask.countOfBytesClientExpectsToReceive)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let dataTask = task as? URLSessionDataTask else {
            return
        }
        guard let download = downloads[dataTask] else {
            return
        }
        
        let handle = files[dataTask]
        try? handle?.close()
        files[dataTask] = nil
        
        downloads[dataTask] = nil
        
        let from = download.plugin.temperatoryPath
        let to = download.plugin.pluginLocation
        
        if FileManager.default.fileExists(atPath: to) {
            try? FileManager.default.removeItem(atPath: to)
        }
        
        do {
            try Zip.unzipFile(URL(string: "file://\(from)")!, destination: URL(string: "file://\(to)")!, overwrite: true, password: nil)
        } catch {
            print(error)
        }
        
        try? FileManager.default.removeItem(at: URL(string: from)!)
        
        DispatchQueue.main.async {
            download.onFinished?(error)
        }
    }
    
}
