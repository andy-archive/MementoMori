//
//  CommentRepository.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/16/23.
//

import Foundation

import RxSwift

/// CommentRepositoryProtocol
final class CommentRepository {
    
    //MARK: - Create Comment
    func create(comment: StoryPost, postID: String) -> Single<APIResult<Void>> {
        
        let requestDTO = CommentCreateRequestDTO(
            content: <#T##String#>,
            postID: <#T##String#>
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .commentCreate(model: requestDTO),
            responseType: CommentCreateResponseDTO.self
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(_):
                return Single<APIResult>.just(.suceessData(Void()))
            case .statusCode(let statusCode):
                if statusCode == 200 { return Single<APIResult>.just(.suceessData(Void())) }
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
}
