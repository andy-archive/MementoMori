//
//  CommentDetailViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import Foundation

import RxCocoa
import RxSwift

final class CommentDetailViewModel: ViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidAppear: Observable<Void>
        let commentTextToUpload: ControlProperty<String>
        let uploadButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        let isCommentValid: Driver<Bool>
        let reloadCommentTableView: Signal<Void>
        let storyItemDidFetch: Signal<StoryPost?>
    }
    
    //MARK: - Properties
    weak var coordinator: StoryContentCoordinator?
    private let commentUseCase: CommentUseCaseProtocol
    private let storyListUseCase: StoryListUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer
    init(
        coordinator: StoryContentCoordinator,
        commentUseCase: CommentUseCaseProtocol,
        storyListUseCase: StoryListUseCaseProtocol
    ) {
        self.coordinator = coordinator
        self.commentUseCase = commentUseCase
        self.storyListUseCase = storyListUseCase
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        let commentValidation = BehaviorRelay(value: false)
        let reloadView = PublishRelay<Void>()
        let storyPostItem = PublishRelay<StoryPost?>()
        let keychain = KeychainRepository.shared
        let storyPostID = keychain.find(key: "", type: .storyID) ?? ""
        
        /// 댓글 화면이 나타난 이후 게시글 요청 (GET)
        input.viewDidAppear
            .withUnretained(self)
            .flatMap { owner, value in
                owner.storyListUseCase.readStoryItem(storyPostID: storyPostID)
            }
            .bind(with: self) { owner, item in
                storyPostItem.accept(item)
            }
            .disposed(by: disposeBag)
        
        /// 댓글 입력 텍스트 유효성 검사
        input.commentTextToUpload
            .withUnretained(self)
            .map { owner, text in
                !text.isEmpty
            }
            .bind(with: self) { owner, isTextValid in
                commentValidation.accept(isTextValid)
            }
            .disposed(by: disposeBag)
        
        /// 댓글 입력 버튼 클릭 시 네트워크 요청 (POST)
        input.uploadButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.commentTextToUpload) { _, commentText in
                let comment = Comment(
                    content: commentText,
                    storyPostID: storyPostID
                )
                return comment
            }
            .withUnretained(self)
            .flatMap { owner, comment in
                owner.commentUseCase.create(comment: comment)
            }
            .bind(with: self) { owner, isCommentUploaded in
                if isCommentUploaded { reloadView.accept(Void()) }
            }
            .disposed(by: disposeBag)
        
        return Output(
            isCommentValid: commentValidation.asDriver(),
            reloadCommentTableView: reloadView.asSignal(),
            storyItemDidFetch: storyPostItem.asSignal()
        )
    }
}
