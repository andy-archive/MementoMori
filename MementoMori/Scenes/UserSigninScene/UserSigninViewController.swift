//
//  UserSigninViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

final class UserSigninViewController: BaseViewController {
    
    private lazy var titleLabel = SigninTitleLabel()
    private lazy var subtitleLabel = SigninSubtitleLabel()
    private lazy var textField = SigninTextField()
    private lazy var nextButton = SigninButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        
        titleLabel.text = "이름 입력"
        subtitleLabel.text = "이름을 ~자 이상으로 입력해주세요 :)"
        nextButton.setTitle("다음", for: .normal)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: subtitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            textField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: textField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            nextButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
