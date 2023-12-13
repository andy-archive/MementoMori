//
//  Story.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

struct Story: Decodable {
    let id: String
    let title: String?
    let content: String?
    let likes: [String]?
    let imageFilePathList: [String]
//    let comments: [Comment]
//    let hashTags: [String]
    let createdAt: String
    let location: String?
    let creator: Creator
    let productID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content, likes
        case imageFilePathList = "image"
//        case comments, hashTags
        case creator
        case createdAt = "time"
        case location = "content1"
        case productID = "product_id"
    }
}

struct Comment: Decodable {
    let id: String
    let content: String
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content, time
    }
}
