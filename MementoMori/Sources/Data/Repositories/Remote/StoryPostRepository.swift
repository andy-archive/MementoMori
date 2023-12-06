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
    
    func read(story: StoryPost, next: String?, limit: String, accessToken: String) -> Single<APIResult<[StoryPost]>> {
        
        let requestDTO = StoryReadRequestDTO(
            next: next ?? nil,
            limit: limit,
            productId: nil
        )
        
        
        let responseDTO = APIManager.shared.request(
            api: .storyRead(model: requestDTO, accessToken: accessToken),
            responseType: StoryReadResponseDTO.self
        )
        
        let single = responseDTO.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return single
    }
        
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>> {
//        <#code#>
//    }
    
}
