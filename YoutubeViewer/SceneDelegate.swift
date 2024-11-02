//
//  SceneDelegate.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var mainWindow: UIWindow?
    var videoDetailWindow: VideoDetailWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        mainWindow = UIWindow(windowScene: windowScene)
        mainWindow?.rootViewController = TabBarController()
        mainWindow?.makeKeyAndVisible()
    }
    
    // カスタムURLスキーム経由でアプリが開かれた時のハンドリング
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("SceneDelegate openURLContexts: \(URLContexts)")
        guard let urlContext = URLContexts.first else {
            return
        }
        let url = urlContext.url
        _ = GIDSignIn.sharedInstance.handle(url)
    }
    
    // ユニバーサルリンク経由でアプリが開かれた時のハンドリング
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("SceneDelegate scene continue")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL,
           let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true) {
            print("url: \(url), components: \(components)")
        }
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
