//
//  SigninSubtitleLabel.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/14.
//

import UIKit

class SigninSubtitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        font = .systemFont(ofSize: 15)
        textColor = Constant.Color.label
        numberOfLines = 0
    }
}
