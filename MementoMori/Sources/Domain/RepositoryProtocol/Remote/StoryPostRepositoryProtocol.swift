//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import RxSwift

protocol StoryPostRepositoryProtocol {
    func create(story: StoryPost) -> Single<APIResult<StoryPost>>
    func read(story: StoryPost) -> Single<APIResult<Void>>
}
