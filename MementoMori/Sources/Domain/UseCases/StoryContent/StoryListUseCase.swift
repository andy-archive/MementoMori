//
//  StoryListUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

final class StoryListUseCase: StoryListUseCaseProtocol {
    
    //MARK: - Properties
    private var pagination = 5
    private var nextCursor: String?
    private var postList = [StoryPost]()
    private let disposeBag = DisposeBag()
    private let storyPostRepository: StoryPostRepositoryProtocol
    private let keychainRepository: KeychainRepositoryProtocol
    
    //MARK: - Initializer
    init(
        storyPostRepository: StoryPostRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.storyPostRepository = storyPostRepository
        self.keychainRepository = keychainRepository
    }
    
    //MARK: - Private Methods
    
    /// 게시글 조회 요청
    private func requestGET(
        nextCursor: String? = nil,
        limit: String,
        productID: String = Constant.Text.productID
    ) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>> {
        let response = storyPostRepository.read(
            next: nextCursor,
            limit: limit,
            productID: productID
        )
        
        return response
    }
    
    /// 에러 시 응답 메시지
    private func logErrorMessage(statusCode: Int) -> String {
        return StoryReadError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
    
    //MARK: - Protocol Methods
    /// 게시글 조회 (비즈니스 로직)
    func readStoryList() -> Observable<[StoryPost]> {
        var limit = String(pagination)
        let observable = Observable.just(Void())
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.requestGET(
                    nextCursor: owner.nextCursor,
                    limit: limit
                )
            }
            .map { result in
                switch result {
                case .suceessData(let list):
                    return list.storyList
                case .statusCode(let statusCode):
                    if statusCode == 419 { return MockData().storyList }
                    return MockData().storyList
                }
            }
            .asObservable()
        
        return observable
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
