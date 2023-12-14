//
//  UserSigninViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class UserSigninViewController: BaseViewController {
    
    //MARK: - (1-1) UI - Property 1
    private lazy var titleLabel = SigninTitleLabel()
    private lazy var subtitleLabel = SigninSubtitleLabel()
    private lazy var emailTextField = SigninTextField()
    private lazy var passwordTextField = SigninTextField()
    private lazy var signinButton = SigninButton()
    private lazy var signinValidationLabel = SigninSubtitleLabel()
    private lazy var joinButton = JoinButton()
    
    //MARK: - (1-2) ViewModel - Property 2
    private let viewModel: UserSigninViewModel
    
    //MARK: - (2) Initializer
    init(viewModel: UserSigninViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - (3-1) Protocol Methods
    override func bind() {
        let input = UserSigninViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty,
            passwordText: passwordTextField.rx.text.orEmpty,
            signinButtonClicked: signinButton.rx.tap,
            joinButtonClicked: joinButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .isSigninButtonEnabled
            .bind(with: self) { owner, value in
                let color = value ? Constant.Color.Button.valid : Constant.Color.Button.notValid
                owner.signinButton.backgroundColor = color
                owner.signinButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output
            .isSigninProcessValid
            .asSignal()
            .emit(with: self) { owner, isProcessValid in
                let color = isProcessValid ? Constant.Color.Label.valid : Constant.Color.Label.notValid
                owner.emailTextField.layer.borderColor = color.cgColor
                owner.passwordTextField.layer.borderColor = color.cgColor
                owner.signinButton.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)
        
        output
            .signinValidationText
            .asSignal()
            .emit(with: self) { owner, validationText in
                owner.signinValidationLabel.text = validationText
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        super.configureUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        titleLabel.text = "로그인"
        
        subtitleLabel.text = "이메일과 비밀번호를 입력하세요"
        
        emailTextField.placeholder = "📧 이메일"
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .continue
        emailTextField.becomeFirstResponder()
        
        passwordTextField.placeholder = "🔒 비밀번호 (8자리 이상)"
        passwordTextField.returnKeyType = .go
        passwordTextField.isSecureTextEntry = true
        
        signinButton.setTitle("다음 ", for: .normal)
        
        signinValidationLabel.textColor = .systemRed
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signinValidationLabel)
        view.addSubview(joinButton)
    }
    
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.Common.Inset.vertical),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            emailTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        signinValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signinValidationLabel.topAnchor.constraint(equalTo: passwordTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            signinValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            signinValidationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signinButton.topAnchor.constraint(equalTo: signinValidationLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            signinButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Common.Size.buttonHeight)
        ])
        
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            joinButton.topAnchor.constraint(equalTo: signinButton.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            joinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            joinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            joinButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Common.Size.buttonHeight)
        ])
    }
    
    //MARK: - (3-2) Class Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension UserSigninViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        default: break
        }
        
        return true
    }
}
