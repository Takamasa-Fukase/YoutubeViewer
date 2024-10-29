//
//  TabBarController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class TabBarController: UITabBarController {
    private var homeVC: HomeViewController!
    private var myPageVC: MyPageViewController!
    private var videoDetailWindow: VideoDetailWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        setVCs()
    }
    
    func showVideoDetailWindow() {
        // 既に存在していたら一度閉じる
        if videoDetailWindow != nil {
            videoDetailWindow?.close()
            videoDetailWindow = nil
        }
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        videoDetailWindow = VideoDetailWindow(windowScene: windowScene, tabBarHeight: tabBar.frame.height)
    }
    
    private func setVCs() {
        var vcs: [UIViewController] = []
        homeVC = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController() as? HomeViewController
        myPageVC = UIStoryboard(name: MyPageViewController.className, bundle: nil).instantiateInitialViewController() as? MyPageViewController
        
        homeVC.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        myPageVC.tabBarItem = .init(title: "You", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        tabBar.tintColor = .label

        vcs.append(contentsOf: [homeVC, myPageVC])
        viewControllers = vcs.map({ vc in
            vc.navigationItem.backButtonDisplayMode = .minimal
            let navi = UINavigationController(rootViewController: vc)
            navi.navigationBar.tintColor = .label
            return navi
        })
        setViewControllers(viewControllers, animated: false)
    }
}
