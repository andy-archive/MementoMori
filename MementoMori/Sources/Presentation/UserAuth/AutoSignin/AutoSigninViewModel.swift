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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    weak var coordinator: AppCoordinator?
    let disposeBag = DisposeBag()
    
    init(
        coordinator: AppCoordinator
    ) {
        self.coordinator = coordinator
    }
    
    
    func transform(input: Input) -> Output {
        
        return Output(
        )
    }
}
