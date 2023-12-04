//
//  BaseView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

import RxSwift

class BaseView: UIView {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureLayout()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = Constant.Color.background
    }
    func configureLayout() { }
    func bind() { }
}
