//
//  UserJoinViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

import RxCocoa
import RxSwift

final class UserJoinViewController: BaseViewController {
    
    private lazy var titleLabel = SigninTitleLabel()
    private lazy var subtitleLabel = SigninSubtitleLabel()
    private lazy var textField = SigninTextField()
    private lazy var nextButton = SigninButton()
    
    private let viewModel = UserJoinViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let input = UserJoinViewModel.Input(text: textField.rx.text.orEmpty, nextButtonClicked: nextButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output
            .isTextValid
            .bind(with: self, onNext: { owner, value in
                let color = value ? Constant.Color.Button.valid : Constant.Color.Button.notValid
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
            })
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        super.configureUI()
        
        titleLabel.text = "이메일 입력"
        subtitleLabel.text = "(조건) 6자 이상이어야 하며, '@'과 '.'는 필수입니다 :)"
        textField.placeholder = "이메일"
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
