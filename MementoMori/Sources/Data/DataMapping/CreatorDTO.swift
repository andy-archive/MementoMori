//
//  Creator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

struct CreatorDTO: Codable {
    let id: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nickname = "nick"
    }
}
