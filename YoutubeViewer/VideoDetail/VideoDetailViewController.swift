//
//  VideoDetailViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

protocol VideoDetailDelegate: AnyObject {
    func showFloatingImageWindow()
    func hideFloatingImageWindow()
    func viewDismissalProgressUpdated(progress: CGFloat)
}

class VideoDetailViewController: UIViewController {
    weak var videoDetailDelegate: VideoDetailDelegate?
    private var initialDragPositionY: CGFloat = 0.0
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        // dismissの進行度合いの割合値を通知
        videoDetailDelegate?.viewDismissalProgressUpdated(progress: dismissalProgress())
        
        // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
        let viewAlpha = 1.0 - (dismissalProgress() * 3.33)
        view.alpha = CGFloat(viewAlpha)
        
        let location = gesture.location(in: view)
        if gesture.state == .began {
            // ジェスチャー開始時点の座標を変数に格納
            initialDragPositionY = location.y
            
            // ImageViewと別WindowのFloatingImageViewをすり替える
            replaceImageViewWithFloatingImage(isViewBeingClosed: true)
        }
        let movedDistanceY = location.y - initialDragPositionY
        let targetPositionY = max(view.frame.origin.y + movedDistanceY, 0.0)
        // 0よりは下回らないようにしつつ、ドラッグの移動距離分Viewも移動させる
        view.frame.origin.y = targetPositionY

        // ジェスチャー終了時（指が離れた時）の処理
        if gesture.state == .ended {
            if dismissalProgress() >= 0.3 {
                // 移動量が画面高さの30％以上ならdismissさせる
                dismiss(animated: true) {
                    self.videoDetailDelegate?.viewDismissalProgressUpdated(progress: 1)
                }
                
            }else {
                // 移動量が画面高さの30%未満なら元に戻す
                UIView.animate(withDuration: 0.4, delay: 0) {
                    self.view.frame.origin.y = 0.0
                    
                    self.videoDetailDelegate?.viewDismissalProgressUpdated(progress: 0)
                    // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
                    let viewAlpha = 1.0 - (self.dismissalProgress() * 3.33)
                    self.view.alpha = CGFloat(viewAlpha)
                    
                } completion: { _ in
                    // ImageViewと別WindowのFloatingImageViewをすり替える
                    self.replaceImageViewWithFloatingImage(isViewBeingClosed: false)
                }
            }
        }
    }
    
    private func replaceImageViewWithFloatingImage(isViewBeingClosed: Bool) {
        videoImageView.isHidden = isViewBeingClosed
        if isViewBeingClosed {
            videoDetailDelegate?.showFloatingImageWindow()
        }else {
            videoDetailDelegate?.hideFloatingImageWindow()
        }
    }
    
    private func dismissalProgress() -> CGFloat {
        // 0.0 ~ 1.0の範囲で返却
        //  - 0.0: フルスクリーン状態
        //  - 1.0: 完全にdismissされた状態
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
        let viewPositionY = view.frame.origin.y
        let screenHeight = windowScene.screen.bounds.height
        let progress = min(viewPositionY / screenHeight, 1.0)
        return CGFloat(progress)
    }
}
