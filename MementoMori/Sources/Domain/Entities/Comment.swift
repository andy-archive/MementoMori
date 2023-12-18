//
//  Comment.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

//MARK: - Entity
struct Comment: Hashable {
    let id: String?
    let content: String?
    let createdAt: String?
    let storyPostID: String?
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id && lhs.content == rhs.content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//MARK: - Initializers
extension Comment {
    
    init(
        id: String,
        content: String,
        storyPostID: String
    ) {
        self.id = id
        self.content = content
        self.createdAt = nil
        self.storyPostID = storyPostID
    }
    
    init(
        content: String,
        storyPostID: String
    ) {
        self.id = nil
        self.content = content
        self.createdAt = nil
        self.storyPostID = storyPostID
    }
}
