//
//  Comment.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

//MARK: - Entity
struct Comment {
    let id: String?
    let content: String?
    let createdAt: String?
    let storyPostID: String?
}

//MARK: - Initializers
extension Comment {
    
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
