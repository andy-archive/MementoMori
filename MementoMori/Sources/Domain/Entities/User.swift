//
//  User.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import UIKit

struct User: Hashable {
    let id: String?
    let email: String?
    let password: String?
    let nickname: String?
    let phoneNum: String?
    let birthday: String?
    let accessToken: String?
    let refreshToken: String?
}
