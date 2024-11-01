//
//  VideoDetailViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit
import Kingfisher
import YoutubePlayer_in_WKWebView

enum VideoDetailScreenMode {
    case fullScreen
    case changing
    case small
}

class VideoDetailViewController: UIViewController {
    var playerBaseView: UIView!
    var screenMode: VideoDetailScreenMode = .fullScreen {
        didSet {
            switch screenMode {
            case .fullScreen:
                playerBaseView.layer.cornerRadius = 0
                playerCloseButton.isHidden = true
            case .changing:
                playerBaseView.layer.cornerRadius = 10
                playerCloseButton.isHidden = true
            case .small:
                playerBaseView.layer.cornerRadius = 10
                playerCloseButton.isHidden = false
            }
        }
    }
    
    private var playerView: WKYTPlayerView?
    private var playerCloseButton: UIButton!
    private var descriptionBaseView: UIView!
    private var backgroundMaskingView: UIView!
    private var initialDragPositionY: CGFloat = 0.0
    private var initialPlayerBaseViewFrame: CGRect!
    private var isShownModalPresentationAnimation = false
    
    // 0.0 ~ 1.0の範囲
    //  - 0.0: フルスクリーン状態
    //  - 1.0: 最小化された状態
    private var minimizationProgress: CGFloat = 0.0 {
        didSet {
            // playerBaseViewのサイズと座標を更新
            updatePlayerBaseViewSizeAndPosition(minimizationProgress: minimizationProgress)
            
            // description部分のViewの透明度を更新（最小化の進行度合いの0.0 ~ 0.3の範囲を1.0 ~ 0.0の割合に変換）
            descriptionBaseView.alpha = 1.0 - (minimizationProgress * 3.33)
            
            // description部分のViewのY座標をplayerBaseViewの下端に合わせて更新
            descriptionBaseView.frame.origin.y = playerBaseView.frame.maxY

            // 背面を暗くしているViewの透明度を更新（最小化の進行度合いの0.0 ~ 0.3の範囲を0.5 ~ 0.0の割合に変換）
            if minimizationProgress >= 0.3 {
                backgroundMaskingView.alpha = (1 - minimizationProgress) * 0.715
            }else {
                backgroundMaskingView.alpha = 0.5
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初回表示時にはモーダル出現風アニメーションを行うため、viewがちらつかない様に予め非表示にしておく
        view.isHidden = true
        
        setupPlayerView()
        setupDescriptionView()
        setupBackgroundMaskingView()

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isShownModalPresentationAnimation {
            isShownModalPresentationAnimation = true
            showModalPresentationAnimation()
        }
    }
    
    private func setupPlayerView() {
        initialPlayerBaseViewFrame = CGRect(
            x: 0,
            y: SceneDelegate.shared?.mainWindow?.safeAreaInsets.top ?? 0,
            width: view.frame.width,
            height: view.frame.width * 0.5625
        )
        playerBaseView = UIView(frame: initialPlayerBaseViewFrame)
        playerBaseView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        playerBaseView.clipsToBounds = true
        playerBaseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlayerViewTap)))
        view.addSubview(playerBaseView)
        
        playerView = WKYTPlayerView(frame: playerBaseView.frame)
        guard let playerView = playerView else { return }
        playerView.delegate = self
        // タッチを透過させて下のplayerBaseViewを反応させる
        playerView.isUserInteractionEnabled = false
        playerBaseView.addSubview(playerView)
        playerBaseView.addConstraints(for: playerView)
        
        playerCloseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        playerCloseButton.isHidden = true
        playerCloseButton.tintColor = .white
        playerCloseButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        playerCloseButton.addTarget(self, action: #selector(handlePlayerCloseButtonTap), for: .touchUpInside)
        playerBaseView.addSubview(playerCloseButton)
    }
    
    private func loadVideo() {
        self.playerView?.load(withVideoId: "O5518678w8U",
                              playerVars: [
                                "playsinline": 1,
                                "modestbranding": 1,
                                "iv_load_policy": 3,
                                "fs": 0,
                                "controls": 0
                              ])
    }
    
    private func setupDescriptionView() {
        descriptionBaseView = UIView(frame: CGRect(x: 0, y: playerBaseView.frame.maxY, width: view.frame.width, height: view.frame.height - playerBaseView.frame.height))
        view.addSubview(descriptionBaseView)
        
        let descriptionView = VideoDetailDescriptionView()
        descriptionBaseView.addSubview(descriptionView)
        descriptionBaseView.addConstraints(for: descriptionView)
    }
    
    private func setupBackgroundMaskingView() {
        backgroundMaskingView = UIView(frame: view.frame)
        backgroundMaskingView.backgroundColor = .black
        backgroundMaskingView.alpha = 0.5
        view.addSubview(backgroundMaskingView)
        view.sendSubviewToBack(backgroundMaskingView)
    }
    
    private func showModalPresentationAnimation() {
        guard screenMode == .fullScreen else { return }
        view.frame.origin.y = UIApplication.shared.screen.bounds.height
        view.isHidden = false
        
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin.y = 0.0
        } completion: { _ in
            self.screenMode = .fullScreen
            self.loadVideo()
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
    
    @objc private func handlePlayerViewTap() {
        guard screenMode == .small else { return }
        
        UIView.animate(withDuration: 0.2) {
            // 最小化の進捗を更新する
            self.minimizationProgress = 0
        } completion: { _ in
            self.screenMode = .fullScreen
        }
    }
    
    @objc  private func handlePlayerCloseButtonTap() {
        playerView?.stopVideo()
        playerView?.removeFromSuperview()
        playerView = nil
        SceneDelegate.shared?.videoDetailWindow?.close()
    }

    func updatePlayerBaseViewSizeAndPosition(minimizationProgress: CGFloat) {
        let destinationWidth = UIApplication.shared.screen.bounds.width * 0.51
        // 高さは16:9の割合の計算で求める(width * 0.5625)
        let destinationHeight = destinationWidth * 0.5625
        // 画面の横幅から(余白, 縮小後のplayerBaseViewの横幅)を差し引く
        let destinationMinX = UIApplication.shared.screen.bounds.width - 8 - destinationWidth
        let tabBarHeight = (SceneDelegate.shared?.mainWindow?.rootViewController as? TabBarController)?.tabBar.frame.height ?? 0.0
        // 画面の高さから(TabBarの高さ, 余白, 縮小後のplayerBaseViewの高さ)を差し引く
        let destinationMinY = UIApplication.shared.screen.bounds.height - tabBarHeight - 8 - destinationHeight

        let currentMinX = currentValue(initialValue: initialPlayerBaseViewFrame.minX,
                                       destinationValue: destinationMinX,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentMinY = currentValue(initialValue: initialPlayerBaseViewFrame.minY,
                                       destinationValue: destinationMinY,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: true)
        let currentWidth = currentValue(initialValue: initialPlayerBaseViewFrame.width,
                                       destinationValue: destinationWidth,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: false)
        let currentHeight = currentValue(initialValue: initialPlayerBaseViewFrame.height,
                                       destinationValue: destinationHeight,
                                       progress: minimizationProgress,
                                       isDestinationValueGreaterThanInitialValue: false)

        let currentPoint = CGPoint(x: (currentMinX - (currentWidth / 2)), y: (currentMinY - (currentHeight / 2)))
        playerBaseView.center = currentPoint
        
        // TODO: absで正の値に戻しているが、なぜ負の値になっているのか調査＆直したい
        let currentSize = CGSize(width: abs(currentWidth), height: abs(currentHeight))
        playerBaseView.bounds.size = currentSize
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

extension VideoDetailViewController: WKYTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        playerView.playVideo()
    }
}
