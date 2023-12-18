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
    /// 에러 시 응답 메시지
    private func verifyErrorMessage(statusCode: Int) -> String {
        let message = CommentCreateError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
        
        return message
    }
    
    //MARK: - Protocol Methods
    /// 댓글 작성 (비즈니스 로직)
    func create(comment: Comment) -> Observable<Comment?> {
        let keychain = KeychainRepository.shared
        
        if let storyID = keychain.find(key: "", type: .storyID) {
            let result = commentRepository.create( comment: comment, postID: storyID )
                .map { result in
                    switch result {
                    case .suceessData:
                        return Optional(comment)
                    case .statusCode:
                        return nil
                    }
                }
                .asObservable()
            
            return result
        }
        
        return Observable.just(nil)
    }
}
