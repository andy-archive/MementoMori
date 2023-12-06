//
//  Story.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

struct Story: Codable {
    let id: String
    let title: String
    let content: String
    let likes: [String]
    let image: [String]
    let comments: [String]
    let hashTags: [String]
    let createdAt: String
    let location: String
    let creator: Creator
    let productID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content
        case likes, image, comments, hashTags
        case creator
        case createdAt = "time"
        case location = "content1"
        case productID = "product_id"
    }
}
