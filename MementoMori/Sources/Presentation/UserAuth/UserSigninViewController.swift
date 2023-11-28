//
//  UserSigninViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class UserSigninViewController: BaseViewController {
    
    private lazy var titleLabel = SigninTitleLabel()
    private lazy var subtitleLabel = SigninSubtitleLabel()
    private lazy var emailTextField = SigninTextField()
    private lazy var passwordTextField = SigninTextField()
    private lazy var signinButton = SigninButton()
    private lazy var signinValidationLabel = SigninSubtitleLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
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
        
        signinButton.setTitle("다음 ", for: .normal)
        signinButton.titleLabel?.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        signinButton.layer.cornerRadius = 15
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signinButton)
        view.addSubview(signinValidationLabel)
    }
    
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical / 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal)
        ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical / 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            emailTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signinButton.topAnchor.constraint(equalTo: passwordTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical),
            signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            signinButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        signinValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signinValidationLabel.topAnchor.constraint(equalTo: signinButton.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.UserAuth.Inset.vertical / 2),
            signinValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.UserAuth.Inset.horizontal),
            signinValidationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.UserAuth.Inset.horizontal),
            signinValidationLabel.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: UITextFieldDelegate

extension UserSigninViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        default: break
        }
        
        return true
    }
}
