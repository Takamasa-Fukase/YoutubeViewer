//
//  VideoDetailViewController2.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit
import Kingfisher

enum VideoDetailScreenMode {
    case fullScreen
    case small
}

class VideoDetailViewController2: UIViewController {
    var screenMode: VideoDetailScreenMode = .fullScreen
    var videoImageView: UIImageView!
    var tabBarHeight: CGFloat = 0.0
    private var initialDragPositionY: CGFloat = 0.0
    private var initialImageViewFrame: CGRect!
    
    @IBOutlet weak var contentBaseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    func showContentRestorationAnimation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let screenHeight = windowScene.screen.bounds.height
        contentBaseView.frame.origin.y = screenHeight * 0.3
        
        UIView.animate(withDuration: 0.2) {
            self.contentBaseView.frame.origin.y = 0.0
            
            // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
            let viewAlpha = 1.0 - (self.dismissalProgress() * 3.33)
            self.contentBaseView.alpha = CGFloat(viewAlpha)
        }
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard screenMode == .fullScreen else { return }
        
        let location = gesture.location(in: view)
        // ジェスチャー開始時の処理
        if gesture.state == .began {
            // 開始時点の座標を変数に格納
            initialDragPositionY = location.y
        }
        
        updateImageViewFrame(dismissalProgress: dismissalProgress(), tabBarHeight: tabBarHeight)
        
        // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
        let viewAlpha = 1.0 - (dismissalProgress() * 3.33)
        contentBaseView.alpha = CGFloat(viewAlpha)

        // 0よりは下回らないようにしつつ、Viewをドラッグの移動距離分移動させる
        let movedDistanceY = location.y - initialDragPositionY
        let targetPositionY = max(contentBaseView.frame.origin.y + movedDistanceY, 0.0)
        contentBaseView.frame.origin.y = targetPositionY

        // ジェスチャー終了時（指が離れた時）の処理
        if gesture.state == .ended {
            // Viewの上端が画面の上から30％以上下がった位置にあれば最小化する
            if dismissalProgress() >= 0.3 {
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.updateImageViewFrame(dismissalProgress: 1, tabBarHeight: self.tabBarHeight)
                }
            }
            // Viewの上端が画面の上から30％よりも上の位置にあればフルスクリーン状態に戻す
            else {
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.contentBaseView.frame.origin.y = 0.0
                    
                    // Viewの透明度を変更（dismissの進行度合いの0.0~0.3の範囲を1.0~0.0の割合に変換）
                    let viewAlpha = 1.0 - (self.dismissalProgress() * 3.33)
                    self.contentBaseView.alpha = CGFloat(viewAlpha)
                    
                    self.updateImageViewFrame(dismissalProgress: 0, tabBarHeight: self.tabBarHeight)
                }
            }
        }
    }
    
    private func dismissalProgress() -> CGFloat {
        // 0.0 ~ 1.0の範囲で返却
        //  - 0.0: フルスクリーン状態
        //  - 1.0: 完全にdismissされた状態
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0.0 }
        let viewPositionY = contentBaseView.frame.origin.y
        let screenHeight = windowScene.screen.bounds.height
        let progress = min(viewPositionY / screenHeight, 1.0)
        return CGFloat(progress)
    }
    
    private func setupImageView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        initialImageViewFrame = CGRect(
            x: 0,
            y: windowScene.keyWindow?.safeAreaInsets.top ?? 0,
            width: view.frame.width,
            height: view.frame.width * 0.5625
        )
        videoImageView = UIImageView(frame: initialImageViewFrame)
        videoImageView.isUserInteractionEnabled = true
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.clipsToBounds = true
        videoImageView.layer.cornerRadius = 8
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        videoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        view.addSubview(videoImageView)
    }
    
    @objc private func handleImageViewTap() {
        guard screenMode == .small else { return }
        
        showContentRestorationAnimation()
        
        UIView.animate(withDuration: 0.2) {
            self.updateImageViewFrame(dismissalProgress: 0, tabBarHeight: self.tabBarHeight)
        }
    }

    func updateImageViewFrame(dismissalProgress: CGFloat, tabBarHeight: CGFloat) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }

        let destinationWidth = windowScene.screen.bounds.width * 0.51
        // 高さは16:9の割合の計算で求める(width * 0.5625)
        let destinationHeight = destinationWidth * 0.5625
        // 画面の横幅から(余白, 縮小後のImageViewの横幅)を差し引く
        let destinationMinX = windowScene.screen.bounds.width - 8 - destinationWidth
        // 画面の高さから(TabBarの高さ, 余白, 縮小後のImageViewの高さ)を差し引く
        let destinationMinY = windowScene.screen.bounds.height - tabBarHeight - 8 - destinationHeight

        let currentMinX = currentValue(initialValue: initialImageViewFrame.minX,
                                       destinationValue: destinationMinX,
                                       progress: dismissalProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentMinY = currentValue(initialValue: initialImageViewFrame.minY,
                                       destinationValue: destinationMinY,
                                       progress: dismissalProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentWidth = currentValue(initialValue: initialImageViewFrame.width,
                                       destinationValue: destinationWidth,
                                       progress: dismissalProgress,
                                       isDestinationValueGreaterThanInitialValue: false)
        let currentHeight = currentValue(initialValue: initialImageViewFrame.height,
                                       destinationValue: destinationHeight,
                                       progress: dismissalProgress,
                                       isDestinationValueGreaterThanInitialValue: false)

        let currentPoint = CGPoint(x: (currentMinX - (currentWidth / 2)), y: (currentMinY - (currentHeight / 2)))
        videoImageView.center = currentPoint
        let currentSize = CGSize(width: currentWidth, height: currentHeight)
        videoImageView.contentMode = .redraw
        videoImageView.bounds.size = currentSize
    }
    
    private func currentValue(
        initialValue: CGFloat,
        destinationValue: CGFloat,
        progress: CGFloat,
        isDestinationValueGreaterThanInitialValue: Bool
    ) -> CGFloat {
        if isDestinationValueGreaterThanInitialValue {
            return (progress * abs(initialValue - destinationValue)) + initialValue
        }else {
            return (progress * abs(initialValue - destinationValue)) - initialValue
        }
    }
}
