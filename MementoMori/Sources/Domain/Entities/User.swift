//
//  User.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import UIKit

struct User: Codable {
    let id: String?
    let email: String
    let password: String?
    let nick: String
    let phoneNum: String?
    let birthday: String?
}
