//
//  UserJoinViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

import RxCocoa

final class UserJoinViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var titleLabel = SigninTitleLabel()
    private lazy var requiredSubtitleLabel = SigninSubtitleLabel()
    private lazy var emailTextField = SigninTextField()
    private lazy var emailValidationButton = SigninButton()
    private lazy var emailValidationLabel = SigninSubtitleLabel()
    private lazy var passwordTextField = SigninTextField()
    private lazy var passwordValidationLabel = SigninSubtitleLabel()
    private lazy var passwordSecureTextButton = SecureTextButton()
    private lazy var nicknameTextField = SigninTextField()
    private lazy var selectiveSubtitleLabel = SigninSubtitleLabel()
    private lazy var phoneNumberTextField = SigninTextField()
    private lazy var birthdayTextField = SigninTextField()
    private lazy var nextButton = SigninButton()
    
    //MARK: - ViewModel
    private let viewModel: UserJoinViewModel
    
    //MARK: - Initializer
    init(
        viewModel: UserJoinViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind ViewController to ViewModel
    override func bind() {
        let input = UserJoinViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty,
            passwordText: passwordTextField.rx.text.orEmpty,
            nicknameText: nicknameTextField.rx.text.orEmpty,
            emailValidationButtonTap: emailValidationButton.rx.tap,
            passwordSecureButtonTap: passwordSecureTextButton.rx.tap,
            nextButtonTap: nextButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.isEmailTextValid
            .asSignal()
            .emit(with: self) { owner, value in
                let color = value ? Constant.Color.Label.valid : Constant.Color.Label.notValid
                owner.emailValidationLabel.textColor = color
                owner.emailTextField.layer.borderColor = color.cgColor
            }
            .disposed(by: disposeBag)
        
        output.isPasswordTextValid
            .asSignal()
            .emit(with: self) { owner, value in
                let textFieldColor = value ? Constant.Color.TextField.valid : Constant.Color.TextField.notValid
                owner.passwordTextField.layer.borderColor = textFieldColor.cgColor
            }
            .disposed(by: disposeBag)
        
        output.isNicknameTextValid
            .asSignal()
            .emit(with: self) { owner, value in
                let textFieldColor = value ? Constant.Color.TextField.valid : Constant.Color.TextField.notValid
                owner.nicknameTextField.layer.borderColor = textFieldColor.cgColor
            }
            .disposed(by: disposeBag)
        
        output.emailValidationMessage
            .asDriver()
            .drive(with: self) { owner, value in
                owner.emailValidationLabel.text = value
            }
            .disposed(by: disposeBag)
        
        output.isPasswordSecure
            .asDriver()
            .drive(with: self) { owner, value in
                let image = value ? Constant.Image.System.eye : Constant.Image.System.eyeSlash
                owner.passwordSecureTextButton.setImage(image, for: .normal)
                owner.passwordTextField.isSecureTextEntry.toggle()
            }
            .disposed(by: disposeBag)
        
        output.isEmailValidationButtonEnabled
            .asDriver()
            .drive(with: self) { owner, value in
                let color = value ? Constant.Color.Button.valid : Constant.Color.Button.notValid
                owner.emailValidationButton.backgroundColor = color
                owner.emailValidationButton.isEnabled = value
            }
            .disposed(by: disposeBag)
        
        output.isNextButtonEnabled
            .bind(with: self) { owner, value in
                let color = value ? Constant.Color.Button.valid : Constant.Color.Button.notValid
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - UI Configuration
    override func configureUI() {
        super.configureUI()
        
        /// Delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nicknameTextField.delegate = self
        
        /// Assignment
        titleLabel.text = "회원 가입"
        requiredSubtitleLabel.text = "필수 입력 사항"
        emailTextField.placeholder = "📧 이메일"
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .continue
        emailTextField.becomeFirstResponder()
        emailTextField.rightViewMode = .always
        emailTextField.rightView = emailValidationButton
        emailValidationButton.setTitle("확인", for: .normal)
        emailValidationButton.layer.cornerRadius = 10
        passwordTextField.placeholder = "🔒 비밀번호 (8자리 이상)"
        passwordTextField.returnKeyType = .continue
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = passwordSecureTextButton
        nicknameTextField.placeholder = "🔖 닉네임 (2~20 자)"
        nicknameTextField.returnKeyType = .continue
        selectiveSubtitleLabel.text = "선택 입력 사항"
        phoneNumberTextField.placeholder = "📱 휴대전화번호"
        phoneNumberTextField.keyboardType = .numberPad
        birthdayTextField.placeholder = "📅 생년월일 8자리"
        birthdayTextField.keyboardType = .numberPad
        nextButton.setTitle("다음 ", for: .normal)
        
        /// View Hierarchy
        view.addSubview(titleLabel)
        view.addSubview(requiredSubtitleLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailValidationLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordValidationLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(selectiveSubtitleLabel)
        view.addSubview(phoneNumberTextField)
        view.addSubview(birthdayTextField)
        view.addSubview(nextButton)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.Layout.Common.Inset.vertical),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        requiredSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            requiredSubtitleLabel.topAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            requiredSubtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            requiredSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: requiredSubtitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            emailTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        emailValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailValidationLabel.topAnchor.constraint(equalTo: emailTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            emailValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            emailValidationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailValidationLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        passwordValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordValidationLabel.topAnchor.constraint(equalTo: passwordTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            passwordValidationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            passwordValidationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
        ])
        
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: passwordValidationLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            nicknameTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        selectiveSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectiveSubtitleLabel.topAnchor.constraint(equalTo: nicknameTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            selectiveSubtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            selectiveSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal)
        ])
        
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: selectiveSubtitleLabel.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical / 2),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        birthdayTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            birthdayTextField.topAnchor.constraint(equalTo: phoneNumberTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            birthdayTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            birthdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            birthdayTextField.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: birthdayTextField.safeAreaLayoutGuide.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            nextButton.heightAnchor.constraint(equalToConstant: Constant.Layout.UserAuth.Size.height)
        ])
    }
    
    //MARK: - Dismiss Keyboard when Tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: UITextFieldDelegate
extension UserJoinViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: nicknameTextField.becomeFirstResponder()
        case nicknameTextField: phoneNumberTextField.becomeFirstResponder()
        default: break
        }
        
        return true
    }
}
