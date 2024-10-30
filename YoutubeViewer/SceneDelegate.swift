//
//  SceneDelegate.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var mainWindow: UIWindow?
    var videoDetailWindow: VideoDetailWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        mainWindow = UIWindow(windowScene: windowScene)
        mainWindow?.rootViewController = TabBarController()
        mainWindow?.makeKeyAndVisible()
    }
    
    func showVideoDetailWindow() {
        // 既に存在していたら一度閉じる
        if videoDetailWindow != nil {
            videoDetailWindow?.close()
            videoDetailWindow = nil
        }
        guard let windowScene = UIApplication.shared.windowScene else { return }
        videoDetailWindow = VideoDetailWindow(windowScene: windowScene)
    }
}
