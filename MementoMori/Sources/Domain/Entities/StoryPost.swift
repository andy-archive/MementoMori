//
//  StoryPost.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import Foundation

//MARK: - Entity
struct StoryPost: Hashable {
    
    enum StoryType {
        case advertisement
        case location
    }
    
    let id: String?
    let userID: String?
    let nickname: String?
    let title: String?
    let content: String
    let imageDataList: [Data]?
    let imageFilePathList: [String]?
    let commentList: [String]?
    let location: String?
    let isLiked: Bool?
    let isSavedToMyCollection: Bool?
    let createdAt: String?
    let storyType: StoryType?
    
    //MARK: - Hashable
    static func == (lhs: StoryPost, rhs: StoryPost) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//MARK: - Initializers
extension StoryPost {
    
    init(content: String, imageDataList: [Data]?) {
        self.id = nil
        self.userID = nil
        self.nickname = nil
        self.title = nil
        self.content = content
        self.imageDataList = imageDataList
        self.imageFilePathList = nil
        self.commentList = nil
        self.location = nil
        self.isLiked = false
        self.isSavedToMyCollection = false
        self.createdAt = nil
        self.storyType = nil
    }
    
    init(
        id: String,
        nickname: String,
        content: String,
        imageFilePathList: [String],
        createdAt: String
    ) {
        self.id = id
        self.userID = nil
        self.nickname = nickname
        self.title = nil
        self.content = content
        self.imageDataList = nil
        self.imageFilePathList = imageFilePathList
        self.commentList = []
        self.location = nil
        self.isLiked = false
        self.isSavedToMyCollection = false
        self.createdAt = createdAt
        self.storyType = .location
    }
}
