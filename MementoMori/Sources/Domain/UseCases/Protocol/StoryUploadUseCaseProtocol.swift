//
//  StoryUploadUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/11/23.
//

import UIKit

import RxSwift

protocol StoryUploadUseCaseProtocol {
    func convertImageToData(image: UIImage) -> Data?
    func fetchStoryUpload(storyPost: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>>
    func verifyStoryUploadProcess(result: APIResult<Void>) -> (isCompleted: Bool, message: String)
}
