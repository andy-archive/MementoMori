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
        let contentText: ControlProperty<String>
    }
    
    struct Output {
        let resultImage: PublishRelay<UIImage>
        let presentStoryUploadView: PublishRelay<Void>
        let presentImageUploadView: PublishRelay<Void>
        let imageUploadMessage: PublishRelay<String>
    }
    
    weak var coordinator: StoryUploadCoordinator?
    let disposeBag = DisposeBag()
    private let storyUploadUseCase: StoryUploadUseCaseProtocol
    
    init(
        coordinator: StoryUploadCoordinator,
        storyUploadUseCase: StoryUploadUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.storyUploadUseCase = storyUploadUseCase
    }
    
    private lazy var uploadProcess: UploadProcessType = .imageUpload
    private lazy var imageList: [Data] = []
    
    func transform(input: Input) -> Output {
        
        let presentStoryUploadView = PublishRelay<Void>()
        let presentImageUploadView = PublishRelay<Void>()
        let contentToUpload = PublishRelay<String>()
        let imageToUpload = PublishRelay<UIImage>()
        let imageUploadMessage = PublishRelay<String>()
        
        let storyPostData = Observable
            .combineLatest(imageToUpload.asObservable(), input.contentText) { [weak self] image, text in
                StoryPost(
                    id: nil,
                    userID: nil,
                    nickname: nil,
                    title: nil,
                    content: text,
                    imageDataList: self?.imageList ?? nil,
                    commentList: nil,
                    location: nil,
                    isLiked: false,
                    isSavedToMyCollection: false,
                    createdAt: nil,
                    storyType: nil
                )
            }
            .share()
        
        input
            .imageSelectionViewClicked
            .subscribe(with: self) { owner, image in
                imageToUpload.accept(image)
                guard let imageData = owner.storyUploadUseCase.convertImageToData(image: image) else { return }
                owner.imageList = [imageData]
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .filter { owner, _ in
                owner.uploadProcess == .imageUpload
            }
            .bind(with: self) { owner, _ in
                owner.uploadProcess = .storyUpload
                presentStoryUploadView.accept(Void())
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(storyPostData)
            .withUnretained(self)
            .filter { owner, _ in
                owner.uploadProcess == .storyUpload
            }
            .flatMap { owner, storyPost in
                owner.storyUploadUseCase.fetchStoryUpload(storyPost: storyPost, imageDataList: owner.imageList)
            }
            .bind(with: self) { owner, result in
                let process = owner.storyUploadUseCase.verifyStoryUploadProcess(result: result)
                process.isCompleted ? owner.coordinator?.finish() : imageUploadMessage.accept(process.message)
            }
            .disposed(by: disposeBag)
        
        input
            .cancelButtonClicked
            .debug()
            .subscribe(with: self) { owner, _ in
                switch owner.uploadProcess {
                case .imageUpload:
                    // 🔥
                    owner.coordinator?.finish()
                case .storyUpload:
                    owner.uploadProcess = .imageUpload
                    presentImageUploadView.accept(Void())
                }
            }
            .disposed(by: disposeBag)
        
        input
            .contentText
            .subscribe(with: self) { owner, text in
                contentToUpload.accept(text)
            }
            .disposed(by: disposeBag)
        
        return Output(
            resultImage: imageToUpload,
            presentStoryUploadView: presentStoryUploadView,
            presentImageUploadView: presentImageUploadView,
            imageUploadMessage: imageUploadMessage
        )
    }
}
