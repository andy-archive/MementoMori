//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import Foundation

import RxSwift

protocol StoryPostRepositoryProtocol {
    func create(story: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>>
    func read(next: String?, limit: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>>
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>>
}
