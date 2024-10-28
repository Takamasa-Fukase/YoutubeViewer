//
//  SceneDelegate.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var floatingWindow: FloatingImageWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = TabBarController()
//        window?.makeKeyAndVisible()
        
//        floatingWindow = FloatingImageWindow(frame: windowScene.screen.bounds)
        floatingWindow = FloatingImageWindow(windowScene: windowScene)
        guard let floatingWindow = floatingWindow else { return }
        floatingWindow.rootViewController = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController()
        floatingWindow.windowLevel = .alert + 1
        floatingWindow.backgroundColor = .systemPink
        floatingWindow.tintColor = .blue
        floatingWindow.makeKeyAndVisible()
        print("floatingWindow.makeKeyAndVisible()")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

