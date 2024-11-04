//
//  Video.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 3/11/24.
//

import Foundation

struct VideosResponse: Decodable {
    let items: [Video]
}

struct Video: Decodable {
    let id: String
    let snippet: Snippet
    
    struct Snippet: Decodable {
        let publishedAt: String
        let title: String
        let description: String
        let thumbnails: Thumbnails
    }
}

struct Thumbnails: Decodable {
    let `default`: Thumbnail?
    let medium: Thumbnail?
    let high: Thumbnail?
    let standard: Thumbnail?
    
    struct Thumbnail: Decodable {
        let url: String
    }
}
