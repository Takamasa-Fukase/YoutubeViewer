//
//  VideoDetailViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit
import Kingfisher
import SwiftUI

enum VideoDetailScreenMode {
    case fullScreen
    case changing
    case small
}

class VideoDetailViewController: UIViewController {
    var videoImageView: UIImageView!
    var screenMode: VideoDetailScreenMode = .fullScreen {
        didSet {
            if screenMode == .fullScreen {
                videoImageView.layer.cornerRadius = 0
            }else {
                videoImageView.layer.cornerRadius = 10
            }
        }
    }
    
    private var descriptionViewContentView: UIView!
    private var initialDragPositionY: CGFloat = 0.0
    private var initialImageViewFrame: CGRect!
    private var isShownModalPresentationAnimation = false
    
    // 0.0 ~ 1.0の範囲
    //  - 0.0: フルスクリーン状態
    //  - 1.0: 最小化された状態
    private var minimizationProgress: CGFloat = 0.0 {
        didSet {
            // ImageViewのサイズと座標を更新
            updateImageViewSizeAndPosition(minimizationProgress: minimizationProgress)
            
            // description部分のViewの透明度を更新（最小化の進行度合いの0.0 ~ 0.3の範囲を1.0 ~ 0.0の割合に変換）
            descriptionViewContentView.alpha = 1.0 - (minimizationProgress * 3.33)
            
            // description部分のViewのY座標をImageViewの下端に合わせて更新
            descriptionViewContentView.frame.origin.y = videoImageView.frame.maxY
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初回表示時にはモーダル出現風アニメーションを行うため、viewがちらつかない様に予め非表示にしておく
        view.isHidden = true
        
        setupImageView()
        setupDescriptionView()

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isShownModalPresentationAnimation {
            isShownModalPresentationAnimation = true
            showModalPresentationAnimation()
        }
    }
    
    private func setupImageView() {
        initialImageViewFrame = CGRect(
            x: 0,
            y: SceneDelegate.shared?.mainWindow?.safeAreaInsets.top ?? 0,
            width: view.frame.width,
            height: view.frame.width * 0.5625
        )
        videoImageView = UIImageView(frame: initialImageViewFrame)
        videoImageView.isUserInteractionEnabled = true
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.clipsToBounds = true
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        videoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap)))
        view.addSubview(videoImageView)
    }
    
    private func setupDescriptionView() {
        let hc = UIHostingController(rootView: VideoDetailDescriptionView())
        descriptionViewContentView = hc.view
        descriptionViewContentView.backgroundColor = .clear
        descriptionViewContentView.frame = CGRect(x: 0, y: videoImageView.frame.maxY, width: view.frame.width, height: view.frame.height - videoImageView.frame.height)
        view.addSubview(descriptionViewContentView)
    }
    
    private func showModalPresentationAnimation() {
        guard screenMode == .fullScreen else { return }
        view.frame.origin.y = UIApplication.shared.screen.bounds.height
        view.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0.0
        }
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if screenMode == .small {
            return
        }
        screenMode = .changing
        
        let location = gesture.location(in: view)
        // ジェスチャー開始時の処理
        if gesture.state == .began {
            // 開始時点の座標を変数に格納
            initialDragPositionY = location.y
        }
        
        // ドラッグ開始地点からの移動距離（0よりは下回らないようにすることで、開始地点より上の移動を除外する）
        let movedDistanceY = max(location.y - initialDragPositionY, 0.0)
        
        // 最小化の進捗を更新する
        minimizationProgress = movedDistanceY / UIApplication.shared.screen.bounds.height

        // ジェスチャー終了時（指が離れた時）の処理
        if gesture.state == .ended {
            // 最小化の進捗が30％以上だったら最小化を完了させる
            if minimizationProgress >= 0.3 {
                UIView.animate(withDuration: 0.2, delay: 0) {
                    // 最小化の進捗を更新する
                    self.minimizationProgress = 1
                } completion: { _ in
                    self.screenMode = .small
                }
            }
            // 最小化の進捗が30％未満だったらフルスクリーン状態に戻す
            else {
                UIView.animate(withDuration: 0.2, delay: 0) {
                    // 最小化の進捗を更新する
                    self.minimizationProgress = 0
                } completion: { _ in
                    self.screenMode = .fullScreen
                }
            }
        }
    }
    
    @objc private func handleImageViewTap() {
        guard screenMode == .small else { return }
        
        UIView.animate(withDuration: 0.2) {
            // 最小化の進捗を更新する
            self.minimizationProgress = 0
        } completion: { _ in
            self.screenMode = .fullScreen
        }
    }

    func updateImageViewSizeAndPosition(minimizationProgress: CGFloat) {
        let destinationWidth = UIApplication.shared.screen.bounds.width * 0.51
        // 高さは16:9の割合の計算で求める(width * 0.5625)
        let destinationHeight = destinationWidth * 0.5625
        // 画面の横幅から(余白, 縮小後のImageViewの横幅)を差し引く
        let destinationMinX = UIApplication.shared.screen.bounds.width - 8 - destinationWidth
        let tabBarHeight = (SceneDelegate.shared?.mainWindow?.rootViewController as? TabBarController)?.tabBar.frame.height ?? 0.0
        // 画面の高さから(TabBarの高さ, 余白, 縮小後のImageViewの高さ)を差し引く
        let destinationMinY = UIApplication.shared.screen.bounds.height - tabBarHeight - 8 - destinationHeight

        let currentMinX = currentValue(initialValue: initialImageViewFrame.minX,
                                       destinationValue: destinationMinX,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentMinY = currentValue(initialValue: initialImageViewFrame.minY,
                                       destinationValue: destinationMinY,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentWidth = currentValue(initialValue: initialImageViewFrame.width,
                                       destinationValue: destinationWidth,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: false)
        let currentHeight = currentValue(initialValue: initialImageViewFrame.height,
                                       destinationValue: destinationHeight,
                                       progress: minimizationProgress,
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
