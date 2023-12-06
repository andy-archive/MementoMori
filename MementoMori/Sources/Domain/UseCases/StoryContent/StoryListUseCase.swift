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
    
    //MARK: - (1) fetchAccessToken
    private func fetchAccessToken() -> (isCompleted: Bool, accessToken: String?) {
        guard let userID = keychainRepository.verify(key: "", type: .userID)
        else { return (false, nil) }
        
        let accessToken = keychainRepository.verify(key: userID, type: .accessToken)
        
        return (true, accessToken)
    }
    
    //MARK: - (2) fetchPostRead
    private func fetchPostRead(nextCursor: String?, limit: String, accessToken: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>> {

        return self.storyPostRepository.read(
            next: nextCursor ?? nil,
            limit: limit,
            accessToken: accessToken
        )
    }
    
    //MARK: - (3) fetchStoryList
    private func fetchStoryList(result: APIResult<(storyList: [StoryPost], nextCursor: String)>) -> [StoryPost] {
        switch result {
        case .suceessData(let list):
            return list.storyList
        case .errorStatusCode(_):
            return MockData().storyList
        }
    }
    
    //MARK: - (4) logErrorMessage
    private func logErrorMessage(statusCode: Int) -> String {
        return StoryReadError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
    
    //MARK: - (MementoAPI) Story GET Request
    func fetchStoryPostList() -> Observable<[StoryPost]> {
        
        let keychainProcess = self.fetchAccessToken()
        
        guard keychainProcess.isCompleted,
              let accessToken = keychainProcess.accessToken else { return Observable.just(MockData().storyList) }
        
        var limit = String(pagination)
        
        return Observable
            .just(Void())
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.fetchPostRead(
                    nextCursor: owner.nextCursor,
                    limit: limit,
                    accessToken: accessToken
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
