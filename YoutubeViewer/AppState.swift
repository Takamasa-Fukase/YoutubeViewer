//
//  AppState.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

final class AppState {
    private init() {}

    static let shared = AppState()
    
    var isSignedIn: Bool = false {
        didSet {
            NotificationCenter.default.post(name: NotificationKey.signInStatusChanged, object: nil)
        }
    }
}
