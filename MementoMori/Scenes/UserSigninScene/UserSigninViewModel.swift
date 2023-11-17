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
        let isTextValid: Observable<Bool>
//        let isEmailValid: BehaviorRelay<Bool>
    }
    
//    private var isEmailValid = false
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let message = BehaviorRelay(value: String())
        
        let isTextValid = input
            .text
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.contains("@") && $0.contains(".") && $0.count >= 6 && $0.count < 50 }
        
        input // ObservableConvertibleType
            .nextButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.text) { _, query in
                return query
            }
            .flatMap { query in
                APIManager.shared.validateEmail(email: query)
            }
            .subscribe(with: self) { owner, response in
                print(owner, response, "==================", separator: "\n")
                message.accept(response.message)
            }
            .disposed(by: disposeBag)
        
        return Output(isTextValid: isTextValid)
    }
}
