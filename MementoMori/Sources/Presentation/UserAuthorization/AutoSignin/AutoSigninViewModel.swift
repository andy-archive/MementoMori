//
//  AutoSigninViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/11/23.
//

import UIKit

import RxCocoa
import RxSwift

final class AutoSigninViewModel: ViewModel {
    
    //MARK: - Input
    struct Input {
        let autoSigninButtonClicked: ControlEvent<Void>
        let otherSigninButtonClicked: ControlEvent<Void>
        let joinSigninButtonClicked: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output { }
    
    //MARK: - Properties
    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    //MARK: - Initializer
    init(
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    //MARK: - Transform Input into Output
    func transform(input: Input) -> Output {
        input
            .otherSigninButtonClicked
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self) { owner, _ in
                owner.coordinator?.showUserSigninViewController()
            }
            .disposed(by: disposeBag)
        
        input
            .joinSigninButtonClicked
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self) { owner, _ in
                owner.coordinator?.showUserJoinViewController()
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
