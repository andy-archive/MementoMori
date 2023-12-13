//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/5/23.
//

import Foundation

import RxSwift

protocol StoryPostRepositoryProtocol {
    func create(storyPost: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>>
    func read(next: String?, limit: String, productID: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>>
}
