//
//  AutoSigninViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/10/23.
//

import UIKit

final class AutoSigninViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = UIFont(name: "Noteworthy", size: 35)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        label.text = "Memento Mori"
        return label
    }()
    
    private lazy var nicknameLabel = {
        let label = SigninSubtitleLabel()
        return label
    }()
    
    private lazy var autoSigninButton = {
        let button = SigninButton()
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    private lazy var otherSigninButton = {
        let button = JoinButton()
        button.setTitle("다른 계정으로 로그인", for: .normal)
        return button
    }()
    
    private lazy var joinButton = {
        let button = JoinButton()
        button.setTitle("새 계정 만들기", for: .normal)
        return button
    }()
    
    //MARK: - ViewModel
    private let viewModel: AutoSigninViewModel
    
    //MARK: - Initializer
    init(viewModel: AutoSigninViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind with ViewModel
    override func bind() {
        AutoSigninViewModel.Input(
            autoSigninButtonClicked: autoSigninButton.rx.tap,
            otherSigninButtonClicked: otherSigninButton.rx.tap,
            joinSigninButtonClicked: joinButton.rx.tap
        )
    }
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(titleLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(autoSigninButton)
        view.addSubview(otherSigninButton)
        view.addSubview(joinButton)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.Common.Inset.vertical),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            nicknameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            nicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        autoSigninButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            autoSigninButton.topAnchor.constraint(equalTo: nicknameLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            autoSigninButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            autoSigninButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            autoSigninButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Common.Size.buttonHeight)
        ])
        
        otherSigninButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            otherSigninButton.topAnchor.constraint(equalTo: autoSigninButton.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            otherSigninButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            otherSigninButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            otherSigninButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Common.Size.buttonHeight)
        ])
        
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            joinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.Layout.Common.Inset.vertical),
            joinButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Common.Size.buttonHeight)
        ])
    }
}
