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
    var isContentsHidden = false
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoImageView.isHidden = isContentsHidden
        view.alpha = (isContentsHidden ? 0 : 1)
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    func showContentRestorationAnimation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let screenHeight = windowScene.screen.bounds.height
        view.frame.origin.y = screenHeight * 0.3
        
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0.0
            
            // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
            let viewAlpha = 1.0 - (self.dismissalProgress() * 3.33)
            self.view.alpha = CGFloat(viewAlpha)
            
        } completion: { _ in
            // この画面内のImageViewと別WindowのFloatingImageViewの表示を切り替える
            self.replaceImageViewWithFloatingImage(isViewBeingClosed: false)
        }
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        // ジェスチャー開始時の処理
        if gesture.state == .began {
            // 開始時点の座標を変数に格納
            initialDragPositionY = location.y
            
            // この画面内のImageViewと別WindowのFloatingImageViewの表示を切り替える
            replaceImageViewWithFloatingImage(isViewBeingClosed: true)
        }
        
        // dismissの進行度合いの割合値を通知
        videoDetailDelegate?.viewDismissalProgressUpdated(progress: dismissalProgress())
        
        // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
        let viewAlpha = 1.0 - (dismissalProgress() * 3.33)
        view.alpha = CGFloat(viewAlpha)

        // 0よりは下回らないようにしつつ、Viewをドラッグの移動距離分移動させる
        let movedDistanceY = location.y - initialDragPositionY
        let targetPositionY = max(view.frame.origin.y + movedDistanceY, 0.0)
        view.frame.origin.y = targetPositionY

        // ジェスチャー終了時（指が離れた時）の処理
        if gesture.state == .ended {
            // Viewの上端が画面の上から30％以上下がった位置にあればdismissさせる
            if dismissalProgress() >= 0.3 {
                dismiss(animated: true)
                
                // dismissに合わせてアニメーション
                UIView.animate(withDuration: 0.2, delay: 0) {
                    // dismissの進行度合いの割合値を通知
                    self.videoDetailDelegate?.viewDismissalProgressUpdated(progress: 1)
                }
            }
            // Viewの上端が画面の上から30％よりも上の位置にあればフルスクリーン状態に戻す
            else {
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.view.frame.origin.y = 0.0
                    
                    // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
                    let viewAlpha = 1.0 - (self.dismissalProgress() * 3.33)
                    self.view.alpha = CGFloat(viewAlpha)
                    
                    // dismissの進行度合いの割合値を通知
                    self.videoDetailDelegate?.viewDismissalProgressUpdated(progress: 0)
                    
                } completion: { _ in
                    // この画面内のImageViewと別WindowのFloatingImageViewの表示を切り替える
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
