//
//  StoryListUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

final class StoryListUseCase: StoryListUseCaseProtocol {
    
    private var pagination = 10
    private var nextCursor: String?
    private var postList = [StoryPost]()
    private let disposeBag = DisposeBag()
    
    private let storyPostRepository: StoryPostRepositoryProtocol
    private let keychainRepository: KeychainRepositoryProtocol
    
    init(
        storyPostRepository: StoryPostRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.storyPostRepository = storyPostRepository
        self.keychainRepository = keychainRepository
    }

    //MARK: - (1) fetchPostRead - storyPostRepository (GET)
    private func fetchPostRead(nextCursor: String?, limit: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>> {

        return self.storyPostRepository.read(
            next: nextCursor ?? nil,
            limit: limit
        )
    }
    
    //MARK: - (2) fetchStoryList
    private func fetchStoryList(result: APIResult<(storyList: [StoryPost], nextCursor: String)>) -> [StoryPost] {
        switch result {
        case .suceessData(let list):
            return list.storyList
        case .errorStatusCode(_):
            return MockData().storyList
        }
    }
    
    //MARK: - (3) logErrorMessage
    private func logErrorMessage(statusCode: Int) -> String {
        return StoryReadError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
    
    //MARK: - (MementoAPI) /post GET Request
    func fetchStoryListStream() -> Observable<[StoryPost]> {
        
        var limit = String(pagination)
        
        return Observable
            .just(Void())
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPostRead(
                    nextCursor: owner.nextCursor,
                    limit: limit
                )
            }
            .withUnretained(self)
            .map { owner, value in
                return owner.fetchStoryList(result: value)
            }
            .asObservable()
    }
        
    //TODO: - pagination
//        single
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .suceessData(let data):
//                    self.nextCursor = data.nextCursor
//                    self.postList = data.storyList
//                    self.pagination += 5
//                case .errorStatusCode(let statusCode):
//                    self.postList = MockData().storyList
//                    self.verifyErrorMessage(statusCode: statusCode)
//                }
//            }
//            .disposed(by: disposeBag)
    
 
}
