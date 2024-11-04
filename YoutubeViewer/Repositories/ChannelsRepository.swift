//
//  ChannelsRepository.swift
//  YoutubeViewer
//
//  Created by ウルトラ深瀬 on 4/11/24.
//

import Foundation
import Alamofire

final class ChannelsRepository {
    func getMyChannels() async throws -> ChannelsResponse {
        let url = URL(string: APIConst.BASE_URL + APIConst.CHANNELS)!
        let request = try URLRequest(url: url, method: .get, headers: APIHeader.applicationJson())
        let parameters: Parameters = [
            "mine": "true",
            "part": "snippet,contentDetails",
            "maxResults": 20,
            "key": Env.googleApiKey
        ]
        let requestConvertible = try URLEncoding.default.encode(request, with: parameters)
        let result = await AF.request(requestConvertible).serializingDecodable(ChannelsResponse.self).result
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
