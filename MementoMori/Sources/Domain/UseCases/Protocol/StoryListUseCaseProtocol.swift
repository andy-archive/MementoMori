//
//  StoryListUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

protocol StoryListUseCaseProtocol {
    func readStoryList() -> Observable<[StoryPost]>
    func readStoryItem(storyPostID: String) -> Observable<StoryPost?>
}
