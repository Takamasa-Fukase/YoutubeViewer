//
//  VideoDetailWindow.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 29/10/24.
//

import UIKit

class VideoDetailWindow: UIWindow {
    init(windowScene: UIWindowScene, tabBarHeight: CGFloat) {
        super.init(windowScene: windowScene)
        let videoDetailVC = UIStoryboard(name: VideoDetailViewController2.className, bundle: nil).instantiateInitialViewController() as! VideoDetailViewController2
        videoDetailVC.tabBarHeight = tabBarHeight
        rootViewController = videoDetailVC
        // TODO: これだとアラートが見えないかもなので、normal+1とかにするか？
        windowLevel = .alert + 1
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        guard let videoDetailVC = rootViewController as? VideoDetailViewController2 else { return nil }
        switch videoDetailVC.screenMode {
        case .fullScreen, .changing:
            return view
        case .small:
            if view == videoDetailVC.videoImageView {
                return view
            } else {
                return nil
            }
        }
    }
    
    func close() {
        isHidden = true
        removeFromSuperview()
    }
}
