//
//  HomeViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 27/10/24.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    weak var videoDetailDelegate: VideoDetailDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

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
        tableView.register(UINib(nibName: HomeVideoListCell.className, bundle: nil), forCellReuseIdentifier: HomeVideoListCell.className)
        tableView.contentInset.top = -8
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoListCell.className, for: indexPath) as! HomeVideoListCell
        let url = URL(string: "https://dol.ismcdn.jp/mwimgs/2/7/650/img_2753004f183b1b28893cb3dc0dc4412a263663.jpg")
        cell.thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo")
        )
        cell.titleLabel.text = "鉄道で行くスイス】アルプス山脈のふもと超絶景山岳リゾートへの車窓の旅“3つのルート” | 地球の歩き方ニュース＆レポート | ダイヤモンド・オンライン"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FloatingImageWindowを閉じる
        (tabBarController as? TabBarController)?.hideFloatingImageWindow()
        
        let vc = UIStoryboard(name: VideoDetailViewController.className, bundle: nil).instantiateInitialViewController() as! VideoDetailViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.videoDetailDelegate = videoDetailDelegate
        present(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
