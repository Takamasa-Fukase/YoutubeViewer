//
//  APIHeader.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation
import Alamofire

final class APIHeader {
    static func applicationJson() -> HTTPHeaders {
        let headers = HTTPHeaders([
            "Content-Type": "application/json",
            "Authorization": "Bearer \(SceneDelegate.shared?.signedInUser?.accessToken.tokenString ?? "")"
        ])
        return headers
    }
}
