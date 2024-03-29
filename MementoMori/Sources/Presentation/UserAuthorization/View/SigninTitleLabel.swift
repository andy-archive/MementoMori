//
//  SigninTitleLabel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/14.
//

import UIKit

final class SigninTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        font = .boldSystemFont(ofSize: Constant.FontSize.largeTitle)
        textColor = Constant.Color.label
        numberOfLines = 1
    }
}
