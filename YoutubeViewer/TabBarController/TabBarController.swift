//
//  TabBarController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 25/10/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setVCs()
    }
    
    private func setVCs() {
        var vcs: [UIViewController] = []
        let homeVC = UIStoryboard(name: HomeViewController.className, bundle: nil).instantiateInitialViewController()
        let myPageVC = UIStoryboard(name: MyPageViewController.className, bundle: nil).instantiateInitialViewController()
        
        guard let homeVC = homeVC,
              let myPageVC = myPageVC else { return }
        
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
