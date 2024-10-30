//
//  VideoDetailWindow.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit

class VideoDetailWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        rootViewController = VideoDetailViewController()
        // TODO: これだとアラートが見えないかもなので、normal+1とかにするか？
        windowLevel = .alert + 1
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event),
              let videoDetailVC = rootViewController as? VideoDetailViewController else { return nil }
        switch videoDetailVC.screenMode {
        case .fullScreen, .changing:
            return view
        case .small:
            print("view: \(view)")
            // 最小化状態ではplayerBaseView自体もしくはそのsubviewsだけタッチを有効にする
            if view == videoDetailVC.playerBaseView ||
                videoDetailVC.playerBaseView.subviews.contains(view) {
                print("return view")
                return view
            }else {
                print("return nil")
                return nil
            }
        }
    }
    
    func close() {
        isHidden = true
        removeFromSuperview()
    }
}
