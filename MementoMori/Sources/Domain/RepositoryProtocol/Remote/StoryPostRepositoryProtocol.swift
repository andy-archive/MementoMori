//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import RxSwift

protocol StoryPostRepositoryProtocol {
//    func create(story: StoryPost) -> Single<APIResult<StoryPost>>
    func read(story: StoryPost, next: String?, limit: String, accessToken: String) -> Single<APIResult<[StoryPost]>>
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>>
}
