//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Furkan on 20.06.2023.
//

import Foundation


struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
