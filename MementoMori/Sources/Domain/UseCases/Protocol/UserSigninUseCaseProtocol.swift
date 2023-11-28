//
//  UserSigninUseCaseProtocol.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import RxRelay

protocol UserSigninUseCaseProtocol {
    var isEmailTextValid: PublishRelay<Bool> { get }
    var isPasswordTextValid: PublishRelay<Bool> { get }
    var isSigninButtonEnabled: BehaviorRelay<Bool> { get }
}
