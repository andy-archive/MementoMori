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
    
    //MARK: - Type
    enum UploadProcessType {
        case imageUpload
        case storyUpload
    }
    
    //MARK: - Input
    struct Input {
        let imageSelectionViewClicked: Observable<UIImage>
        let nextButtonClicked: ControlEvent<Void>
        let cancelButtonClicked: ControlEvent<Void>
        let contentText: ControlProperty<String>
    }
    
    //MARK: - Output
    struct Output {
        let resultImage: PublishRelay<UIImage>
        let presentStoryUploadView: PublishRelay<Void>
        let presentImageUploadView: PublishRelay<Void>
        let imageUploadMessage: PublishRelay<String>
    }
    
    //MARK: - Properties
    weak var coordinator: StoryUploadCoordinator?
    private let storyUploadUseCase: StoryUploadUseCaseProtocol
    private let disposeBag = DisposeBag()
    private lazy var uploadProcess: UploadProcessType = .imageUpload
    private lazy var imageList: [Data] = []
    
    //MARK: - Initializer
    init(
        coordinator: StoryUploadCoordinator,
        storyUploadUseCase: StoryUploadUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.storyUploadUseCase = storyUploadUseCase
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        let presentStoryUploadView = PublishRelay<Void>()
        let presentImageUploadView = PublishRelay<Void>()
        let contentToUpload = PublishRelay<String>()
        let imageToUpload = PublishRelay<UIImage>()
        let contentTextToUpload = BehaviorRelay<String>(value: "")
        let imageUploadMessage = PublishRelay<String>()
        let storyPostData = Observable
            .combineLatest(
                imageToUpload.asObservable(),
                input.contentText
            ) { [weak self] image, text in
                
                StoryPost(
                    content: text,
                    imageDataList: self?.imageList
                )
            }
            .share()
        
        input
            .contentText
            .bind(with: self) { owner, text in
                contentTextToUpload.accept(text)
            }
            .disposed(by: disposeBag)
        
        input
            .imageSelectionViewClicked
            .subscribe(with: self) { owner, image in
                imageToUpload.accept(image)
                guard let imageData = owner.storyUploadUseCase.convertImageToData(image: image)
                else { return }
                owner.imageList = [imageData]
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .filter { owner, _ in
                owner.uploadProcess == .imageUpload &&
                !owner.imageList.isEmpty
            }
            .bind(with: self) { owner, _ in
                owner.uploadProcess = .storyUpload
                presentStoryUploadView.accept(Void())
            }
            .disposed(by: disposeBag)
        
        input
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .filter { owner, _ in
                owner.uploadProcess == .storyUpload &&
                !contentTextToUpload.value.isEmpty &&
                contentTextToUpload.value != Constant.Text.Input.uploadPost
            }
            .withLatestFrom(storyPostData)
            .withUnretained(self)
            .flatMap { owner, storyPost in
                owner.storyUploadUseCase.fetchStoryUpload(storyPost: storyPost, imageDataList: owner.imageList)
            }
            .bind(with: self) { owner, result in
                let process = owner.storyUploadUseCase.verifyStoryUploadProcess(result: result)
                process.isCompleted ?
                owner.coordinator?.finish() :
                imageUploadMessage.accept(process.message)
            }
            .disposed(by: disposeBag)
        
        input
            .cancelButtonClicked
            .subscribe(with: self) { owner, _ in
                switch owner.uploadProcess {
                case .imageUpload:
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
