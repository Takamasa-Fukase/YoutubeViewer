//
//  FloatingImageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

class FloatingImageViewController: UIViewController {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var dummyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        videoImageView.layer.cornerRadius = 6
        dummyImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        dummyImageView.layer.cornerRadius = 6
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        print("videoImageViewのframe: \(videoImageView.frame)") // (0.0, 59.0, 393.0, 221.0)
//        print("dummyImageViewのframe: \(dummyImageView.frame)") // (184.66666666666663, 653.0, 200.33333333333334, 107.0)
//    }
    
    func updateImageViewFrame(dismissalProgress: Float) {
        print("FloatingImageViewController updateImageViewFrame dismissalProgress: \(dismissalProgress)")

        // まずTabBarの高さを取得とそれに加える余白を元に、maxYを決める（screenHeight - TabBarHeight + 余白）
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0.0
        print("tabBarHeight: \(tabBarHeight)")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let newWidth = windowScene.screen.bounds.width * 0.51
        // 横幅が決まれば高さは16:9の割合の計算で求める(* 0.5625)
        let newHeight = newWidth * 0.5625
        //  また、端末の横幅（screenWidth）から0.51倍したやつを横幅にし、右端に余白分をつけた状態でのmaxXを決める
        let minX = windowScene.screen.bounds.width - (newWidth) - 8
        // TODO: + 余白を追加する
        let maxY = windowScene.screen.bounds.height - tabBarHeight
        let minY = maxY - newHeight
        // minY（frameのYに入れる値）はmaxY - ImageViewの高さ
        // minX（frameのXに入れる値）はmaxX - ImageViewの横幅
        
        let newFrame = CGRect(x: minX,           //   0.0 ~ 184.6
                              y: minY,           //  59.0 ~ 653.0
                              width: newWidth,   // 393.0 ~ 200.3
                              height: newHeight) // 221.0 ~ 107.0
        print("newFrame: \(newFrame)")
        videoImageView.frame = newFrame
    }
}
