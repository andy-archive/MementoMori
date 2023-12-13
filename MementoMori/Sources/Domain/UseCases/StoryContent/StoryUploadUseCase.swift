//
//  StoryUploadUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/11/23.
//

import UIKit

import RxSwift
import Moya

final class StoryUploadUseCase: StoryUploadUseCaseProtocol {
    
    private let storyPostRepository: StoryPostRepositoryProtocol
    
    init(
        storyPostRepository: StoryPostRepositoryProtocol
    ) {
        self.storyPostRepository = storyPostRepository
    }
    
    //MARK: - private function
    private func verifyErrorMessage(statusCode: Int) -> String {
        return StoryCreateError(rawValue: statusCode)?.message ??
        NetworkError(rawValue: statusCode)?.message ??
        NetworkError.internalServerError.message
    }
    
    //MARK: - StoryUploadUseCaseProtocol
    func convertImageToData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.5)
    }
    
    func fetchStoryUpload(storyPost: StoryPost, imageDataList: [Data]) -> Single<APIResult<Void>> {
        self.storyPostRepository.create(storyPost: storyPost, imageDataList: imageDataList)
    }
    
    func verifyStoryUploadProcess(result: APIResult<Void>) -> (isCompleted: Bool, message: String) {
        switch result {
        case .suceessData(_):
            return (true, "업로드를 성공하였습니다.")
        case .statusCode(let statusCode):
            let errorMessage = verifyErrorMessage(statusCode: statusCode)
            return (false, errorMessage)
        }
    }
    
}
