//
//  StoryCreateDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import Foundation

//MARK: - Request
struct StoryCreateRequestDTO: Encodable {
    let content: String
    let imageDataList: [Data]
    let productID: String
    
    enum CodingKeys: String, CodingKey {
        case content
        case imageDataList = "file"
        case productID = "product_id"
    }
}

//MARK: - Response
struct StoryCreateResponseDTO: Decodable {
    let id: String
    let title: String
    let content: String
    let image: [String]
//    let likes: [String]
//    let hashTags: [String]
//    let comments: [String]
    let creator: Creator
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content, image
//        case likes, hashTags, comments
        case creator, time
    }
}
