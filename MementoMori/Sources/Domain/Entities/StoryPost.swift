//
//  StoryPost.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import Foundation

struct StoryPost: Hashable {
    
    enum StoryType {
        case advertisement
        case location
    }
    
    let id: String
    let userID: String
    let nickname: String
    let title: String
    let content: String
    let imageNameList: [String]
    let commentList: [String]
    let location: String?
    let isLiked: Bool
    let isSavedToMyCollection: Bool
    let createdAt: String
    let storyType: StoryType
    
    static func == (lhs: StoryPost, rhs: StoryPost) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
