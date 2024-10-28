//
//  FloatingImageWindow.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit

class FloatingImageWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        rootViewController = FloatingImageViewController()
        isUserInteractionEnabled = false
        windowLevel = .alert + 1
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func close() {
        isHidden = true
        removeFromSuperview()
    }
    
    func updateImageViewFrame(dismissalProgress: Float, tabBarHeight: CGFloat) {
        if let floatingImageVC = rootViewController as? FloatingImageViewController {
            floatingImageVC.updateImageViewFrame(dismissalProgress: dismissalProgress, tabBarHeight: tabBarHeight)
        }
    }
}
