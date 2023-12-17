//
//  CommentUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/17/23.
//

import Foundation

import RxSwift

final class CommentUseCase: CommentUseCaseProtocol {
    
    //MARK: - Properties
    private let commentRepository: CommentRepositoryProtocol
    private let keychainRepository: KeychainRepositoryProtocol
    
    //MARK: - Initializer
    init(
        commentRepository: CommentRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.commentRepository = commentRepository
        self.keychainRepository = keychainRepository
    }
    
    //MARK: - Private Methods
    /// 댓글 작성 요청
    private func requestPOST(comment: Comment) -> Single<APIResult<Void>> {
        let keychain = KeychainRepository.shared
        
        if let storyID = keychain.find(key: "", type: .storyID) {
            let response = commentRepository.create(
                comment: comment,
                postID: storyID
            )
            return response
        }
        
        let single = Single<APIResult<Void>>.just(
            .statusCode( CommentCreateError.conflict.rawValue )
        )
        
        return single
    }
    
    /// 에러 시 응답 메시지
    private func verifyErrorMessage(statusCode: Int) -> String {
        let message = CommentCreateError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
        
        return message
    }
    
    //MARK: - Protocol Methods
    /// 댓글 작성 (비즈니스 로직)
    func create(comment: Comment) -> Observable<Bool> {
        let observable =  Observable.just(Void())
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.requestPOST(comment: comment)
            }
            .map { result in
                switch result {
                case .suceessData:
                    return true
                case .statusCode(let statusCode):
                    if statusCode == 200 { return true }
                    return false
                }
            }
            .asObservable()
        
        return observable
    }
}
