//
//  TabBarController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class TabBarController: UITabBarController {
    private var floatingImageWindow: FloatingImageWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        setVCs()
    }
    
    private func setVCs() {
        var vcs: [UIViewController] = []
        let homeVC = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController() as! HomeViewController
        let myPageVC = UIStoryboard(name: MyPageViewController.className, bundle: nil).instantiateInitialViewController() as! MyPageViewController
        
        homeVC.videoDetailDelegate = self
        homeVC.tabBarItem = .init(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        myPageVC.tabBarItem = .init(title: "You", image: UIImage(systemName: "person"), tag: 1)

        vcs.append(contentsOf: [homeVC, myPageVC])
        viewControllers = vcs.map({ vc in
            vc.navigationItem.backButtonDisplayMode = .minimal
            let navi = UINavigationController(rootViewController: vc)
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
        }
    }
    
    func hideFloatingImageWindow() {
        floatingImageWindow?.close()
        floatingImageWindow = nil
    }
    
    func viewDismissalProgressUpdated(progress: Float) {
        print("TabBarController viewDismissalProgressUpdated progress: \(progress)")
        floatingImageWindow?.updateImageViewFrame(dismissalProgress: progress)
    }
}
