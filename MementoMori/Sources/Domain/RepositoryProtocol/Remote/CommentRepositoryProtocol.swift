//
//  CommentRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/17/23.
//

import Foundation

import RxSwift

protocol CommentRepositoryProtocol {
    func create(comment: Comment, postID: String) -> Single<APIResult<Void>>
}
