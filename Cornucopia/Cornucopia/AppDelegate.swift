//
//  AppDelegate.swift
//  Cornucopia
//
//  Created by shayanbo on 2023/5/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        
        let home = HomeController()
        home.tabBarItem = UITabBarItem(title: "Installed", image: UIImage(systemName: "house.fill"), tag: 0)
        home.navigationItem.title = "Installed"
        
        let pluginCenter = GroceryController()
        pluginCenter.tabBarItem = UITabBarItem(title: "Grocery", image: UIImage(systemName: "square.and.arrow.down.fill"), tag: 0)
        pluginCenter.navigationItem.title = "Grocery"
        
        let more = MoreController()
        more.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis"), tag: 0)
        more.navigationItem.title = "More"
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: home),
            UINavigationController(rootViewController: pluginCenter),
            UINavigationController(rootViewController: more),
        ]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController;
        self.window?.makeKeyAndVisible()
        return true
    }
}

