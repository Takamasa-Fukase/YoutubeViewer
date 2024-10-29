//
//  TabBarController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class TabBarController: UITabBarController {
    private var floatingImageWindow: FloatingImageWindow?
    private var homeVC: HomeViewController!
    private var myPageVC: MyPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setVCs()
    }
    
    private func setVCs() {
        var vcs: [UIViewController] = []
        homeVC = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController() as? HomeViewController
        myPageVC = UIStoryboard(name: MyPageViewController.className, bundle: nil).instantiateInitialViewController() as? MyPageViewController
        
        homeVC.videoDetailDelegate = self
        myPageVC.videoDetailDelegate = self

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

extension TabBarController: VideoDetailDelegate {
    func showFloatingImageWindow() {
        if floatingImageWindow == nil {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            floatingImageWindow = FloatingImageWindow(windowScene: windowScene)
            floatingImageWindow?.setDelegate(self)
        }
    }
    
    func hideFloatingImageWindow() {
        floatingImageWindow?.close()
        floatingImageWindow = nil
    }
    
    func viewDismissalProgressUpdated(progress: CGFloat) {
        floatingImageWindow?.updateImageViewFrame(dismissalProgress: progress, tabBarHeight: tabBar.frame.height)
    }
}

extension TabBarController: FloatingImageVCDelegate {
    func imageViewTapped() {
        if selectedIndex == 0 {
            homeVC.restoreMiniPlayerToFullScreen()
        }
        else if selectedIndex == 1 {
            myPageVC.restoreMiniPlayerToFullScreen()
        }
    }
}
