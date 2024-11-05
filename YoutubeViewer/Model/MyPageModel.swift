//
//  MyPageModels.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 5/11/24.
//

import Foundation

struct ProfileModel {
    let thumbnailUrl: String
    let title: String
}

struct PlaylistModel {
    let id: String
    let title: String
    var videos: [PlaylistVideo]
}
