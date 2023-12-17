//
//  ViewModel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/15.
//

import Foundation

import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
