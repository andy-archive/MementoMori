//
//  Story.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

struct Story: Codable {
    let id: String
    let likes: [String]
    let image: [String]
    let hashTags, comments: [String]
    let creator: Creator
    let time: String
    let title, content, productID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case likes, image, hashTags, comments
        case creator, time, title, content
        case productID = "product_id"
    }
}
