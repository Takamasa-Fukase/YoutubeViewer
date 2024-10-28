//
//  VideoDetailViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

class VideoDetailViewController: UIViewController {
    private var initialDragPositionY: CGFloat = 0.0
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        if gesture.state == .began {
            // ジェスチャー開始時点の座標を変数に格納
            initialDragPositionY = location.y
        }
        let movedDistanceY = location.y - initialDragPositionY
        let targetPositionY = max(view.frame.origin.y + movedDistanceY, 0.0)
        // 0よりは下回らないようにしつつ、ドラッグの移動距離分Viewも移動させる
        view.frame.origin.y = targetPositionY
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if gesture.state == .ended {
            // ジェスチャー終了時（指が離れた時）に画面の半分より下ならdismiss、上なら元に戻す
            if view.frame.origin.y > windowScene.screen.bounds.midY {
                dismiss(animated: true)
            }else {
                UIView.animate(withDuration: 0.4, delay: 0) {
                    self.view.frame.origin.y = 0.0
                }
            }
        }
    }
}
