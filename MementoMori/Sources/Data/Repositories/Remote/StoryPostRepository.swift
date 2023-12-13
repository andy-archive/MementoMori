//
//  StoryPostRepositoryProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/6/23.
//

import Foundation

import RxSwift

final class StoryPostRepository: StoryPostRepositoryProtocol {
    
    func create(storyPost: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>> {
        
        let requestDTO = StoryCreateRequestDTO(
            content: storyPost.content,
            imageDataList: imageDataList,
            productID: Constant.Text.productID
        )
        
        let resonseSingle = APIManager.shared.request(
            api: .storyCreate(model: requestDTO),
            responseType: StoryCreateResponseDTO.self,
            apiType: .multipart
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
            case .statusCode(let statusCode):
                return Single<APIResult>.just(.statusCode(statusCode))
            }
        }
        
        return resultSingle
    }
        
//    func readProduct(story: StoryPost, next: String?, limit: String, productId: String, accessToken: String) -> Single<APIResult<Void>> {
//        <#code#>
//    }
    
}
