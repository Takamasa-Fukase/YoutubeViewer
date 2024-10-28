//
//  FloatingImageWindow.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 28/10/24.
//

import UIKit

class FloatingImageWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
//        super.init(frame: UIScreen.main.bounds)
        print("FloatingImageWindow init")
//        rootViewController = UIStoryboard(name: FloatingImageViewController.className, bundle: nil).instantiateInitialViewController()
//        windowLevel = .alert + 1
//        backgroundColor = .systemPink
//        tintColor = .blue
//        makeKeyAndVisible()
    }
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func close() {
        isHidden = true
        removeFromSuperview()
    }
}
