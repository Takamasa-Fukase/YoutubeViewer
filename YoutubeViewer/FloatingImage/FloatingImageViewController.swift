//
//  FloatingImageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

class FloatingImageViewController: UIViewController {
    var videoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
    }
    
    private func setupImageView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        videoImageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: windowScene.keyWindow?.safeAreaInsets.top ?? 0,
                width: view.frame.width,
                height: view.frame.width * 0.5625
            )
        )
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.clipsToBounds = true
        videoImageView.layer.cornerRadius = 6
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        view.addSubview(videoImageView)
    }

    func updateImageViewFrame(dismissalProgress: Float, tabBarHeight: CGFloat) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let newWidth = windowScene.screen.bounds.width * 0.51
        // 高さは16:9の割合の計算で求める(width * 0.5625)
        let newHeight = newWidth * 0.5625
        // 画面の横幅から(余白, ImageViewの高さ)を差し引く
        let minX = windowScene.screen.bounds.width - 8 - newWidth
        // 画面の高さから(TabBarの高さ, 余白, ImageViewの高さ)を差し引く
        let minY = windowScene.screen.bounds.height - tabBarHeight - 4 - newHeight
        
        let newFrame = CGRect(x: minX,           //   0.0 ~ 184.6
                              y: minY,           //  59.0 ~ 653.0
                              width: newWidth,   // 393.0 ~ 200.3
                              height: newHeight) // 221.0 ~ 107.0
        videoImageView.frame = newFrame
    }
}
