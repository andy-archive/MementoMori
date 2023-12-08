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
    
    //MARK: - UI (1) uploadImageView
    private lazy var headerView = StoryUploadHeaderView()
    private lazy var imageItemView = {
        let view = UIImageView()
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
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
    
    //MARK: - UI (2) uploadStoryView
    private lazy var storyImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        return view
    }()
    private lazy var storyTextView = {
        let view = UITextView()
        view.text = "문구를 입력하세요..."
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
    
    //MARK: - Properties
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
        
        self.imagePicker.delegate = self
        self.storyTextView.delegate = self
    }
    
    //MARK: - bind with ViewModel
    override func bind() {
        
        let image = imageListView
            .rx
            .tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.imagePicker.pickImage()
            }
            .share()
        let input = StoryUploadViewModel.Input(
            imageSelectionViewClicked: image,
            nextButtonClicked: self.headerView.nextButton.rx.tap,
            cancelButtonClicked: self.headerView.cancelButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output
            .resultImage
            .asSignal()
            .emit(with: self) { owner, image in
                owner.imageItemView.image = image
                owner.storyImageView.image = image
            }
            .disposed(by: disposeBag)
        
        output
            .presentStoryUploadView
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.presentStoryUploadView()
            }
            .disposed(by: disposeBag)
        
        output
            .presentImageUploadView
            .asSignal()
            .emit(with: self) { owner, _ in
                owner.presentImageUploadView()
            }
            .disposed(by: disposeBag)
    }
    
    //MARK: - View Hierarchies
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
        view.addSubview(imageItemView)
        view.addSubview(imageListView)
        view.addSubview(storyImageView)
        view.addSubview(storyTextView)
        view.addSubview(separatorView)
        imageListView.addSubview(selectionGuideLabel)
    }
    
    //MARK: - View Layouts (1) uploadImageView
    override func configureLayout() {
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
            imageItemView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            imageItemView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        imageListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageListView.topAnchor.constraint(equalTo: imageItemView.bottomAnchor),
            imageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        selectionGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionGuideLabel.topAnchor.constraint(equalTo: imageListView.topAnchor, constant: Constant.Layout.Common.Inset.vertical * 3),
            selectionGuideLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            selectionGuideLabel.centerXAnchor.constraint(equalTo: imageListView.centerXAnchor)
        ])
        
        //MARK: - View Layouts (2) uploadTextView
        storyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            storyImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            storyImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            storyImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
        ])
        
        storyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTextView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            storyTextView.leadingAnchor.constraint(equalTo: storyImageView.trailingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            storyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            storyTextView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
        ])
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyTextView.topAnchor.constraint(greaterThanOrEqualTo: storyTextView.topAnchor),
            separatorView.bottomAnchor.constraint(equalTo: storyTextView.bottomAnchor, constant: Constant.Layout.Common.Inset.vertical),
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - dismiss keyboard in touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - transition view
extension StoryUploadViewController {
    
    private func presentImageUploadView() {
        headerView.cancelButton.setImage(Constant.Image.System.xMark, for: .normal)
        headerView.nextButton.setTitle("다음", for: .normal)
        imageListView.isHidden.toggle()
        imageItemView.isHidden.toggle()
        storyImageView.isHidden.toggle()
        storyTextView.isHidden.toggle()
        separatorView.isHidden.toggle()
    }
    
    private func presentStoryUploadView() {
        headerView.cancelButton.setImage(Constant.Image.System.chevronLeft, for: .normal)
        headerView.nextButton.setTitle("공유", for: .normal)
        imageListView.isHidden.toggle()
        imageItemView.isHidden.toggle()
        storyImageView.isHidden.toggle()
        storyTextView.isHidden.toggle()
        separatorView.isHidden.toggle()
    }
}

//MARK: - UITextViewDelegate
extension StoryUploadViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == Constant.Color.secondaryLabel else { return }
        textView.text = nil
        textView.textColor = Constant.Color.label
    }
}
