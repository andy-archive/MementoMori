//
//  StoryListCoordinator.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryContentCoordinator: Coordinator {
    
    //MARK: - Properties
    weak var delegate: CoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    //MARK: - Initializer
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    //MARK: - Start
    func start() {
        showStoryListViewController()
    }
}

//MARK: - ViewControllers
extension StoryContentCoordinator {
    
    /// 게시글 목록 화면
    func showStoryListViewController() {
        let viewModel = StoryListViewModel(
            coordinator: self,
            storyListUseCase: makeStoryListUseCase()
        )
        let viewController =  StoryListViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /// 댓글 화면 (in SheetPresentation)
    func showCommentDetailViewController() {
        let repository = CommentRepository()
        let useCase = CommentUseCase(
            commentRepository: repository,
            keychainRepository: makeKeychainRepository()
        )
        let viewModel = CommentDetailViewModel(
            coordinator: self,
            commentUseCase: useCase,
            storyListUseCase: makeStoryListUseCase()
        )
        let viewController = CommentDetailViewController(viewModel: viewModel)
        
        viewController.changeToSheetPresentation()
        navigationController.present(viewController, animated: true)
    }
}

//MARK: - Repositories
private extension StoryContentCoordinator {
    
    /// Keychain
    func makeKeychainRepository() -> KeychainRepositoryProtocol {
        return KeychainRepository.shared
    }
}

//MARK: - UseCases
private extension StoryContentCoordinator {
    
    /// StoryList
    func makeStoryListUseCase() -> StoryListUseCaseProtocol {
        let repository = StoryPostRepository()
        let useCase = StoryListUseCase(
            storyPostRepository: repository,
            keychainRepository: makeKeychainRepository()
        )
        return useCase
    }
}
