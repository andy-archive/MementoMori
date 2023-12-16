//
//  StoryUploadViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

import RxGesture
import RxSwift

final class StoryUploadViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = StoryUploadHeaderView()
    
    private lazy var imageItemView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var imageListView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var selectionGuideLabel = {
        let label = UILabel()
        label.text = "이미지 선택 📸"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: Constant.FontSize.largeTitle)
        return label
    }()
    
    private lazy var storyThumbnailImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var storyTextView = {
        let view = UITextView()
        view.text = Constant.Text.Input.uploadPost
        view.textColor = Constant.Color.secondaryLabel
        view.font = .systemFont(ofSize: Constant.FontSize.title)
        view.isHidden = true
        return view
    }()
    
    private lazy var separatorView = {
        let view = SeparatorView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - ViewModel
    private let viewModel: StoryUploadViewModel
    private let imagePicker: ImagePickerController
    
    //MARK: - Initializer
    init(
        viewModel: StoryUploadViewModel,
        imagePicker: ImagePickerController
    ) {
        self.viewModel = viewModel
        self.imagePicker = imagePicker
        
        super.init()
    }
    
    //MARK: - Bind with ViewModel
    override func bind() {
        let image = imageListView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.imagePicker.pickImage()
            }
            .share()
        let input = StoryUploadViewModel.Input(
            imageSelectionViewClicked: image,
            nextButtonClicked: headerView.nextButton.rx.tap,
            cancelButtonClicked: headerView.cancelButton.rx.tap,
            contentText: storyTextView.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.resultImage
            .asSignal()
            .emit(with: self) { owner, image in
                owner.imageItemView.image = image
                owner.storyThumbnailImageView.image = image
            }
            .disposed(by: disposeBag)
        
        output.presentStoryUploadView
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.presentStoryUploadView()
            }
            .disposed(by: disposeBag)
        
        output.presentImageUploadView
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.presentImageUploadView()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - View Configuration
    override func configureUI() {
        super.configureUI()
        
        imagePicker.delegate = self
        storyTextView.delegate = self
        
        view.addSubview(headerView)
        view.addSubview(imageItemView)
        view.addSubview(imageListView)
        view.addSubview(storyThumbnailImageView)
        view.addSubview(storyTextView)
        view.addSubview(separatorView)
        imageListView.addSubview(selectionGuideLabel)
    }
    
    override func configureLayout() {
        
        //MARK: - Layout (1) uploadImageView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        imageItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageItemView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            imageItemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageItemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageItemView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        imageListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageListView.topAnchor.constraint(equalTo: imageItemView.bottomAnchor),
            imageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageListView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4)
        ])
        
        selectionGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionGuideLabel.centerXAnchor.constraint(equalTo: imageListView.centerXAnchor),
            selectionGuideLabel.centerYAnchor.constraint(equalTo: imageListView.centerYAnchor)
        ])
        
        //MARK: - Layout (2) storyUploadView
        storyThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyThumbnailImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            storyThumbnailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            storyThumbnailImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            storyThumbnailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
        ])
        
        storyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            storyTextView.leadingAnchor.constraint(equalTo: storyThumbnailImageView.trailingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            storyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            storyTextView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(greaterThanOrEqualTo: storyTextView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: storyTextView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Dismiss Keyboard in Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - View Transition
extension StoryUploadViewController {
    
    private func presentImageUploadView() {
        headerView.cancelButton.setImage(Constant.Image.System.xMark, for: .normal)
        headerView.nextButton.setTitle("다음", for: .normal)
        imageListView.isHidden.toggle()
        imageItemView.isHidden.toggle()
        storyThumbnailImageView.isHidden.toggle()
        storyTextView.isHidden.toggle()
        separatorView.isHidden.toggle()
    }
    
    private func presentStoryUploadView() {
        headerView.cancelButton.setImage(Constant.Image.System.chevronLeft, for: .normal)
        headerView.nextButton.setTitle("공유", for: .normal)
        imageListView.isHidden.toggle()
        imageItemView.isHidden.toggle()
        storyThumbnailImageView.isHidden.toggle()
        storyTextView.isHidden.toggle()
        separatorView.isHidden.toggle()
    }
}

//MARK: - UITextViewDelegate
extension StoryUploadViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        headerView.cancelButton.isHidden = true
        headerView.newPostLabel.text = "문구"
        
        guard textView.textColor == Constant.Color.secondaryLabel
        else { return }
        
        textView.text = nil
        textView.textColor = Constant.Color.label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.Text.Input.comment
            textView.textColor = Constant.Color.secondaryLabel
        }
        headerView.cancelButton.isHidden = false
        headerView.newPostLabel.text = "새 게시물"
    }
}
