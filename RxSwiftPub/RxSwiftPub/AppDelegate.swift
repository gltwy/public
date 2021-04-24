//
//  AppDelegate.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: RootViewController())
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }

}

