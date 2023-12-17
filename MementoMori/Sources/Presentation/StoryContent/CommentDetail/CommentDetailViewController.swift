//
//  CommentDetailViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/15/23.
//

import UIKit

final class CommentDetailViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = {
        let view = UIView()
        return view
    }()
    
    private lazy var scrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.backgroundColor = Constant.Color.background
        return view
    }()
    
    private lazy var contentView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.background
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constant.FontSize.title)
        label.textColor = Constant.Color.label
        label.numberOfLines = 1
        label.text = "댓글"
        return label
    }()
    
    private lazy var separatorView = SeparatorView()
    
    private lazy var writerContentLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.subtitle)
        label.textColor = Constant.Color.label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentTableView = UITableView()
    
    private lazy var commentInputView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var commentInputTextView = {
        let view = UITextView()
        view.textColor = Constant.Color.label
        view.font = .systemFont(ofSize: Constant.FontSize.title)
        view.layer.cornerRadius = 20
        view.keyboardType = .twitter
        return view
    }()
    
    private lazy var inputPlaceholderLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.subtitle)
        label.text = Constant.Text.Input.comment
        label.textColor = Constant.Color.secondaryLabel
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var createPostButton = {
        let button = UIButton()
        button.setImage(
            Constant.Image.System.arrowUp,
            for: .normal
        )
        return button
    }()
    
    //MARK: - ViewModel
    private let viewModel: CommentDetailViewModel
    
    //MARK: - Initializer
    init(
        viewModel: CommentDetailViewModel
    ) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Bind with ViewModel
    override func bind() {
        let input = CommentDetailViewModel.Input(
            commentTextToUpload: commentInputTextView.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.isCommentValid
            .drive(with: self) { owner, isCommentValid in
                owner.inputPlaceholderLabel.isHidden = isCommentValid
                owner.createPostButton.isHidden = !isCommentValid
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        /// View Hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(commentTableView)
        contentView.addSubview(commentInputView)
        contentView.addSubview(writerContentLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(separatorView)
        commentInputView.addSubview(commentInputTextView)
        commentInputView.addSubview(inputPlaceholderLabel)
        commentInputView.addSubview(createPostButton)
    }
    
    //MARK: - Layouts
    override func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        /// ContentView Height - Priority
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.CommentDetail.Header.height)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -Constant.Layout.CommentDetail.Header.inset),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.widthAnchor.constraint(equalTo: headerView.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        ])
        
        writerContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writerContentLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constant.Layout.CommentDetail.inset),
            writerContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.CommentDetail.inset),
            writerContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Layout.CommentDetail.inset),
            writerContentLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 120)
        ])
        
        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTableView.topAnchor.constraint(equalTo: writerContentLabel.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentTableView.bottomAnchor.constraint(lessThanOrEqualTo: commentInputView.topAnchor),
        ])
        
        commentInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentInputView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        commentInputTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentInputTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal * 3),
            commentInputTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            commentInputTextView.bottomAnchor.constraint(equalTo: commentInputView.bottomAnchor, constant: -Constant.Layout.CommentDetail.inset),
            commentInputTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        inputPlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputPlaceholderLabel.leadingAnchor.constraint(equalTo: commentInputTextView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal / 2),
            inputPlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: commentInputTextView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            inputPlaceholderLabel.centerYAnchor.constraint(equalTo: commentInputTextView.centerYAnchor)
        ])
        
        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createPostButton.trailingAnchor.constraint(equalTo: commentInputTextView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            createPostButton.centerYAnchor.constraint(equalTo: commentInputTextView.centerYAnchor)
        ])
    }
    
    //MARK: - Dismiss Keyboard in Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - Data
extension CommentDetailViewController {
    
    func configure(_ storyPost: StoryPost?) {
        guard let storyPost else { return }
        
    }
}
