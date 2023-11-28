//
//  JoinButton.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class JoinButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        setTitle("회원 가입", for: .normal)
        setTitleColor(Constant.Color.label, for: .normal)
        backgroundColor = Constant.Color.background
        layer.borderWidth = 1
        layer.borderColor = Constant.Color.label.cgColor
        titleLabel?.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        layer.cornerRadius = 15
    }
}
