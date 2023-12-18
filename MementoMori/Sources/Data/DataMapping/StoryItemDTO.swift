//
//  StoryItemDTO.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

//MARK: - Request
struct StoryItemRequestDTO: Encodable {
    let id: String
    let productID: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
    }
}

//MARK: - Response
struct StoryItemResponseDTO: Decodable {
    let id: String
    let title: String?
    let content: String?
    let likes: [String]?
    let imageFilePathList: [String]
    let comments: [CommentDTO]
//    let hashTags: [String]
    let createdAt: String
    let location: String?
    let creator: CreatorDTO
    let productID: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, content, likes
        case imageFilePathList = "image"
        case comments, creator
//      case hashTags
        case createdAt = "time"
        case location = "content1"
        case productID = "product_id"
    }
    
    func toDomain() -> StoryPost {
        let commentList = comments.map { comment in
            comment.toDomain()
        }
        
        let storyPost = StoryPost(
            id: id,
            nickname: creator.nickname,
            content: content ?? "",
            commentList: commentList,
            createdAt: createdAt
        )
        
        return storyPost
    }
}
