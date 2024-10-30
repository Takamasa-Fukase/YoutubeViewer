//
//  SceneDelegate+Extension.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 30/10/24.
//

import UIKit

extension SceneDelegate {
    static var shared: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    }
}
