//
//  MyPageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit

class MyPageViewController: UIViewController {
    weak var videoDetailDelegate: VideoDetailDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        setNaviBarRightButton(systemImageName: "gearshape") {
            
        }
        setNaviBarRightButton(systemImageName: "magnifyingglass") {
            
        }
    }
    
    func restoreMiniPlayerToFullScreen() {
        let vc = UIStoryboard(name: VideoDetailViewController.className, bundle: nil).instantiateInitialViewController() as! VideoDetailViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.videoDetailDelegate = self.videoDetailDelegate
        vc.isContentsHidden = true
        self.present(vc, animated: false) {
            vc.showContentRestorationAnimation()
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: MyPageProfileCell.className, bundle: nil), forCellReuseIdentifier: MyPageProfileCell.className)
        tableView.register(UINib(nibName: MyPageHorizontalListCell.className, bundle: nil), forCellReuseIdentifier: MyPageHorizontalListCell.className)
    }
}

extension MyPageViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageProfileCell.className, for: indexPath) as! MyPageProfileCell
            cell.profileIconImageView.kf.setImage(with: URL(string: "https://pbs.twimg.com/profile_images/1424201228997652486/QTsSmHDC_400x400.jpg"), placeholder: UIImage(systemName: "person.fill"))
            cell.nameLabel.text = "ウルトラ深瀬の激渋歌ってみた"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyPageHorizontalListCell.className, for: indexPath) as! MyPageHorizontalListCell
            cell.titleLabel.text = "History"
            cell.myPageHorizontalListDelegate = self
            return cell
        }
    }
}

extension MyPageViewController: MyPageHorizontalListDelegate {
    func itemSelected(at indexPath: IndexPath) {
        // FloatingImageWindowを閉じる
        (tabBarController as? TabBarController)?.hideFloatingImageWindow()
        
        let vc = UIStoryboard(name: VideoDetailViewController.className, bundle: nil).instantiateInitialViewController() as! VideoDetailViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.videoDetailDelegate = videoDetailDelegate
        present(vc, animated: true)
    }
}
