//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import RxSwift

protocol StoryPostRepositoryProtocol {
//    func create(story: StoryPost) -> Single<APIResult<StoryPost>>
    func read(next: String?, limit: String, accessToken: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>>
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>>
}
