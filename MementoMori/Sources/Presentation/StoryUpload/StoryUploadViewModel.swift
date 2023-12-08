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
    
    enum UploadProcessType {
        case imageUpload
        case storyUpload
    }
    
    struct Input {
        let imageSelectionViewClicked: Observable<UIImage>
        let nextButtonClicked: ControlEvent<Void>
        let cancelButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let resultImage: PublishRelay<UIImage>
        let presentStoryUploadView: PublishRelay<Void>
        let presentImageUploadView: PublishRelay<Void>
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
    
    private var uploadProcess: UploadProcessType = .imageUpload
    
    func transform(input: Input) -> Output {
        
        let selectedImage = PublishRelay<UIImage>()
        let presentStoryUploadView = PublishRelay<Void>()
        let presentImageUploadView = PublishRelay<Void>()
        
        input
            .imageSelectionViewClicked
            .subscribe(with: self) { _, image in
                selectedImage.accept(image)
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .subscribe(with: self) { owner, _ in
                switch owner.uploadProcess {
                case .imageUpload:
                    owner.uploadProcess = .storyUpload
                    presentStoryUploadView.accept(Void())
                case .storyUpload:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        input
            .cancelButtonClicked
            .subscribe(with: self) { owner, _ in
                switch owner.uploadProcess {
                case .imageUpload:
                    return
                case .storyUpload:
                    owner.uploadProcess = .imageUpload
                    presentImageUploadView.accept(Void())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            resultImage: selectedImage,
            presentStoryUploadView: presentStoryUploadView,
            presentImageUploadView: presentImageUploadView
        )
    }
}
