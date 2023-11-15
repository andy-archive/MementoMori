//
//  UserSigninViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class UserSigninViewModel: ViewModelType {
    
    struct Input {
        let text: ControlProperty<String>
        let nextButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let isTextValid: BehaviorRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let isValid = BehaviorRelay(value: false)
        
        input
            .text
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.contains("@") && $0.contains(".") && $0.count >= 6 && $0.count < 50 }
            .bind(to: isValid)
            .disposed(by: disposeBag)
        
        return Output(isTextValid: isValid)
    }
}
