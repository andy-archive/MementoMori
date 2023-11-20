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
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rectWidth = bounds.height * 1.2
        let rectHeight = bounds.height * 0.6
        let inset: CGFloat = 20
        
        let x = bounds.width - rectWidth - inset / 2
        let y = inset / 2
        
        return CGRect(x: x, y: y, width: rectWidth, height: rectHeight)
    }
}
