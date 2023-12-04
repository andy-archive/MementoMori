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
    
    static func == (lhs: StoryPost, rhs: StoryPost) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let userId: String
    let storyType: StoryType
    let imageIdList: [String]?
    let commentIdList: [String]?
    let location: String?
    let isLiked: Bool?
    let isSavedToMyCollection: Bool?
    let content: String?
    let createdAt: Date?
}
