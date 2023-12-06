//
//  StoryListUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

protocol StoryListUseCaseProtocol {
    func fetchStoryPostList() -> Observable<[StoryPost]>
}
