//
//  Channel.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation

struct ChannelsResponse: Decodable {
    let items: [Channel]
}

struct Channel: Decodable {
    let id: String
    let snippet: Snippet
    
    struct Snippet: Decodable {
        let publishedAt: String
        let title: String
        let description: String
        let thumbnails: Thumbnails
    }
}
