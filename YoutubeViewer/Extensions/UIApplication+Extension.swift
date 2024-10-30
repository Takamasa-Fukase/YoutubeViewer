//
//  UIApplication+Extension.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 30/10/24.
//

import UIKit

extension UIApplication {
    var windowScene: UIWindowScene? {
        return connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
    
    var screen: UIScreen {
        guard let screen = windowScene?.screen else {
            print("screenの取得に失敗しました")
            return UIScreen()
        }
        return screen
    }
}
