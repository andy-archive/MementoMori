//
//  SecureTextButton.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/20.
//

import UIKit

final class SecureTextButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        setImage(Constant.Image.System.eye, for: .normal)
    }
}
