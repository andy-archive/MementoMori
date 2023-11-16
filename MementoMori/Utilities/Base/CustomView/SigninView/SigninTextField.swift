//
//  SigninTextField.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

class SigninTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        paddingOnLeft(inset: Constant.Layout.UserAuth.Inset.horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        font = .systemFont(ofSize: Constant.FontSize.title)
        textAlignment = .left
        borderStyle = .line
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}
