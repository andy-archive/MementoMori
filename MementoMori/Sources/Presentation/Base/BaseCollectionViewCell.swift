//
//  BaseCollectionViewCell.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func bind() { }
    
    func configureUI() {
        contentView.backgroundColor = Constant.Color.background
    }
    
    func configureLayout() { }
}
