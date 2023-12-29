//
//  UserProfileHeaderView.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/19/23.
//

import UIKit

final class UserProfileHeaderView: BaseView {
    
    //MARK: - UI
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = Constant.Color.label
        label.font = .boldSystemFont(ofSize: Constant.FontSize.headerTitle)
        label.numberOfLines = 1
        label.text = "USER_NAME" ///TEST
        return label
    }()
    
    private lazy var addButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = Constant.Image.System.plusSquare
        config.buttonSize = .medium
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        button.configuration = config
        return button
    }()
    
    private lazy var listButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = Constant.Image.System.listDash
        config.buttonSize = .medium
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        button.configuration = config
        return button
    }()
    
    private lazy var separatorView = SeparatorView()
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        addSubview(titleLabel)
        addSubview(addButton)
        addSubview(listButton)
        addSubview(separatorView)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: addButton.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical / 2)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topAnchor),
            addButton.trailingAnchor.constraint(equalTo: listButton.leadingAnchor, constant: -Constant.Layout.Common.Inset.horizontal / 2),
            addButton.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical / 2)
        ])
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listButton.topAnchor.constraint(equalTo: topAnchor),
            listButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            listButton.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical / 2)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
