//
//  SeparatorView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/4/23.
//

import UIKit

final class SeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        layer.backgroundColor = UIColor.systemGray3.cgColor
        heightAnchor.constraint(equalToConstant: 0.7).isActive = true
    }
}
