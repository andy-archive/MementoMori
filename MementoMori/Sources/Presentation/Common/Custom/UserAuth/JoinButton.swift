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
        titleLabel?.font = .systemFont(ofSize: Constant.FontSize.title)
        backgroundColor = Constant.Color.background
        layer.borderWidth = 0.5
        layer.borderColor = Constant.Color.systemGray.cgColor
        layer.cornerRadius = 20
        layer.masksToBounds = false
    }
}
