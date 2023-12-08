//
//  StoryUploadViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

import RxCocoa
import RxSwift

final class StoryUploadViewModel: ViewModel {
    
    struct Input {
        let imageSelectionViewClicked: Observable<UIImage>
    }
    
    struct Output {
        let resultImage: PublishRelay<UIImage>
    }
    
    weak var coordinator: StoryUploadCoordinator?
    let disposeBag = DisposeBag()
//    private let storyUploadUseCase: StoryUploadUseCaseProtocol
    
    init(
        coordinator: StoryUploadCoordinator
//        storyUploadUseCase: StoryUploadUseCaseProtocol
    ) {
        self.coordinator = coordinator
//        self.storyUploadUseCase = storyUploadUseCase
    }
    
    func transform(input: Input) -> Output {
        
        let selectedImage = PublishRelay<UIImage>()
        
        input
            .imageSelectionViewClicked
            .subscribe(with: self) { owner, image in
                selectedImage.accept(image)
            }
            .disposed(by: disposeBag)
        
        return Output(
            resultImage: selectedImage
        )
    }
    
}
