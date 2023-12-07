//
//  StoryCreateDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import Foundation

//MARK: - Request
struct StoryCreateRequestDTO: Encodable {
    let title: String
    let content: String
    let imageFileList: [Data]
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case title, content
        case imageFileList = "file"
        case address = "content1"
    }
}

//MARK: - Response
struct StoryCreateResponseDTO: Decodable {
    let id: String
    let title: String
    let content: String
    let likes: [String]
    let image: [String]
    let hashTags: [String]
    let comments: [String]
    let creator: Creator
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content, likes, image
        case hashTags, comments, creator, time
    }
}
