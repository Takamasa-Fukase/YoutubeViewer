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
    var signedInUser: GIDGoogleUser? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("signedInUserChanged"), object: nil, userInfo: ["signedInUser": signedInUser])
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        Task {
            do {
                // ログイン状態を確認してisSignedIn変数を更新
                let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                signedInUser = user
            } catch {
                print("GIDSignIn.sharedInstance.restorePreviousSignIn error: \(error)")
                signedInUser = nil
            }
        }
        
        mainWindow = UIWindow(windowScene: windowScene)
        mainWindow?.rootViewController = TabBarController()
        mainWindow?.makeKeyAndVisible()
        
        // ユニバーサルリンク経由でのアプリ起動のハンドリング
        if let userActivity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }),
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            print("url: \(url)")
        }
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
    
    // ユニバーサルリンク経由でアプリが開かれた時のハンドリング（アプリが既に起動中の場合）
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("SceneDelegate scene continue")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            print("url: \(url)")
        }
    }
    
    func showVideoDetailWindow(video: Video) {
        // 既に存在していたら一度閉じる
        if videoDetailWindow != nil {
            videoDetailWindow?.close()
            videoDetailWindow = nil
        }
        guard let windowScene = UIApplication.shared.windowScene else { return }
        videoDetailWindow = VideoDetailWindow(windowScene: windowScene, video: video)
    }
}
