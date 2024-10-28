//
//  FloatingImageViewController.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit
import Kingfisher

class FloatingImageViewController: UIViewController {
    private var initialImageViewFrame: CGRect!
    private var videoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
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
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.clipsToBounds = true
        videoImageView.layer.cornerRadius = 6
        videoImageView.kf.setImage(with: URL(string: "https://www.tabemaro.jp/wp-content/uploads/2023/06/27910319_m-1700x1133.jpg"))
        view.addSubview(videoImageView)
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
        
        print("currentMinX: \(currentMinX)")
        print("currentMinY: \(currentMinY)")
//        print("currentWidth: \(currentWidth)")
//        print("currentHeight: \(currentHeight)")

        let newFrame = CGRect(x: currentMinX,
                              y: currentMinY,
                              width: currentWidth,
                              height: currentHeight)
        videoImageView.contentMode = .redraw
        videoImageView.frame = newFrame
//        videoImageView.bounds = newFrame
        let size = CGSize(width: currentWidth, height: currentHeight)
        let pointPlus = CGPoint(x: (currentMinX + (currentWidth / 2)), y: (currentMinY + (currentHeight / 2)))
        let point = CGPoint(x: (currentMinX - (currentWidth / 2)), y: (currentMinY - (currentHeight / 2)))
//        print("size: \(size)")
        print("point正しいやつ: \(point)")
        print("point違うやつ: \(pointPlus)\n")
        
        videoImageView.bounds.size = size
        videoImageView.center = point

        /*
         let newFrame = CGRect(x: scaledMinX,        //   0.0 ~ 184.6
                               y: scaledMinY,        //  59.0 ~ 653.0
                               width: scaledWidth,   // 393.0 ~ 200.3
                               height: scaledHeight) // 221.0 ~ 107.0

         */
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
