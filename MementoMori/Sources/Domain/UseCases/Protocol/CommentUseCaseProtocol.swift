//
//  CommentUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/17/23.
//

import Foundation

import RxSwift

protocol CommentUseCaseProtocol {
    func create(comment: Comment) -> Observable<Comment?>
}
