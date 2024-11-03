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
            print("sceneDelegate signedInUser didSet: \(signedInUser)")
            NotificationCenter.default.post(name: Notification.Name("signedInUserChanged"), object: nil, userInfo: ["signedInUser": signedInUser])
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        Task {
            do {
                print("ログイン状態を確認してisSignedIn変数を更新")
                // ログイン状態を確認してisSignedIn変数を更新
                let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
                print("userを取得完了: \(user)")
                print("token: \(user.accessToken.tokenString)")
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
            guard let tabBarController = mainWindow?.rootViewController as? TabBarController else { return }
            guard let index = handleDeepLink(urlComponents: components) else {
                tabBarController.setTitle("willConnectTo経由 no index")
                return
            }
            tabBarController.setTitle("willConnectTo経由 \(index)")
            tabBarController.selectTab(index: index)
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
            
            guard let tabBarController = mainWindow?.rootViewController as? TabBarController else { return }
            guard let index = handleDeepLink(urlComponents: components) else {
                tabBarController.setTitle("continue経由 no index")
                return
            }
            tabBarController.setTitle("continue経由 \(index)")
            tabBarController.selectTab(index: index)
        }
    }
    
    func handleDeepLink(urlComponents: URLComponents) -> Int? {
        if urlComponents.path.contains("home") {
            return 0
        }else if urlComponents.path.contains("profile") {
            return 1
        }else {
            return nil
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
