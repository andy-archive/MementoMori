//
//  SigninButton.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/14.
//

import UIKit

final class SigninButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: Constant.FontSize.subtitle)
        backgroundColor = .systemBlue
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
