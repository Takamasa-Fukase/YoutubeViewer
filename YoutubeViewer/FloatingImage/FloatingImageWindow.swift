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
        windowLevel = .alert + 1
        makeKeyAndVisible()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if let floatingImageVC = rootViewController as? FloatingImageViewController,
           view == floatingImageVC.videoImageView {
            return view
        }
        else {
            return nil
        }
    }
    
    func setDelegate(_ delegate: FloatingImageVCDelegate) {
        if let floatingImageVC = rootViewController as? FloatingImageViewController {
            floatingImageVC.floatingImageVCDelegate = delegate
        }
    }
    
    func close() {
        isHidden = true
        removeFromSuperview()
    }
    
    func updateImageViewFrame(dismissalProgress: CGFloat, tabBarHeight: CGFloat) {
        if let floatingImageVC = rootViewController as? FloatingImageViewController {
            floatingImageVC.updateImageViewFrame(dismissalProgress: dismissalProgress, tabBarHeight: tabBarHeight)
        }
    }
}
