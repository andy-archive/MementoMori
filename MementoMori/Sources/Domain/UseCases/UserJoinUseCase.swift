//
//  UserJoinUseCase.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/26/23.
//

import RxCocoa
import RxSwift

protocol UserJoinUseCaseProtocol {
    var isEmailTextValid: PublishRelay<Bool> { get }
    var isPasswordTextValid: PublishRelay<Bool> { get }
    var isNicknameTextValid: PublishRelay<Bool> { get }
    var emailValidationMessage: BehaviorRelay<String> { get }
    var isPasswordSecure: BehaviorRelay<Bool> { get }
    var isEmailValidationButtonEnabled: BehaviorRelay<Bool> { get }
    var isNextButtonEnabled: BehaviorRelay<Bool> { get }
    var joinResponse: PublishRelay<Result<Void>> { get }
    func join(user: UserJoinRequestDTO) -> Single<Void>
}
