//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

final class StoryPostRepository: StoryPostRepositoryProtocol {
    
//    func create(story: StoryPost) -> Single<APIResult<StoryPost>> {
//        <#code#>
//    }
    
    func read(next: String?, limit: String, accessToken: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>> {
        
        let requestDTO = StoryReadRequestDTO(
            next: next ?? nil,
            limit: limit,
            productID: nil
        )
        
        let singleResponseDTO = APIManager.shared.request(
            api: .storyRead(model: requestDTO, accessToken: accessToken),
            responseType: StoryReadResponseDTO.self
        )
        
        let singleResult = singleResponseDTO.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return singleResult
    }
        
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>> {
//        <#code#>
//    }
    
}
