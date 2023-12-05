//
//  StoryImage.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import Foundation

struct StoryImage: Hashable {
    
    let id: String
    let userId: String
    let storyPostId: String
        
    static func == (lhs: StoryImage, rhs: StoryImage) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
