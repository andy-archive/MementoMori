//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

final class StoryPostRepository: StoryPostRepositoryProtocol {
    
    func create(story: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>> {
        
        let requestDTO = StoryCreateRequestDTO(
            title: story.title,
            content: story.content,
            imageFileList: imageDataList,
            address: story.location
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .storyCreate(model: requestDTO),
            responseType: StoryReadResponseDTO.self
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(_):
                return Single<APIResult>.just(.suceessData(Void()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return resultSingle
    }
    
    func read(next: String?, limit: String) -> Single<APIResult<(storyList: [StoryPost], nextCursor: String)>> {
        
        let requestDTO = StoryReadRequestDTO(
            next: next ?? nil,
            limit: limit,
            productID: nil
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .storyRead(model: requestDTO),
            responseType: StoryReadResponseDTO.self
        )
        
        let resultSingle = resonseSingle.flatMap { result in
            switch result {
            case .suceessData(let responseDTO):
                return Single<APIResult>.just(.suceessData(responseDTO.toDomain()))
            case .errorStatusCode(let statusCode):
                return Single<APIResult>.just(.errorStatusCode(statusCode))
            }
        }
        
        return resultSingle
    }
        
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>> {
//        <#code#>
//    }
    
}
