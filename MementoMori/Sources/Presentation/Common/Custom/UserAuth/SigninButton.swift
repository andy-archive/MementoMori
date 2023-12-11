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
        titleLabel?.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        backgroundColor = .systemBlue
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 20
        layer.masksToBounds = false
    }
}
