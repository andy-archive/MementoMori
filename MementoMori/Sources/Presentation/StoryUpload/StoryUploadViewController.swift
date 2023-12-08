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
    private lazy var photoItemView = UIImageView()
    private lazy var photoListView = UIView()
    private lazy var selectGuideLabel = {
        let label = UILabel()
        label.text = "🙌 이미지를 선택하세요"
        label.font = .systemFont(ofSize: Constant.FontSize.title)
        return label
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
    }
    
    //MARK: - override functions
    override func bind() {
        
        let image = photoListView
            .rx
            .tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.imagePicker.pickImage()
            }
            .share()
        
        let input = StoryUploadViewModel.Input(
            imageSelectionViewClicked: image
        )
        let output = viewModel.transform(input: input)
        
        output
            .resultImage
            .asSignal()
            .emit(with: self) { owner, image in
                owner.photoItemView.image = image
            }
            .disposed(by: disposeBag)
    }
    
    override func configureUI() {
        super.configureUI()
        
        //MARK: - UI Tests
        photoItemView.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        photoListView.backgroundColor = .systemGray4
        
        //MARK: - View Hierarchies
        view.addSubview(headerView)
        view.addSubview(photoItemView)
        view.addSubview(photoListView)
        photoListView.addSubview(selectGuideLabel)
    }
    
    //MARK: - View Layouts
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        photoItemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoItemView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            photoItemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoItemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoItemView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        photoListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoListView.topAnchor.constraint(equalTo: photoItemView.bottomAnchor),
            photoListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        selectGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectGuideLabel.leadingAnchor.constraint(greaterThanOrEqualTo: photoListView.leadingAnchor, constant: Constant.Layout.Common.Inset.horizontal),
            selectGuideLabel.trailingAnchor.constraint(lessThanOrEqualTo: photoListView.trailingAnchor, constant: -Constant.Layout.Common.Inset.horizontal),
            selectGuideLabel.centerXAnchor.constraint(equalTo: photoListView.centerXAnchor),
            selectGuideLabel.centerYAnchor.constraint(equalTo: photoListView.centerYAnchor)
        ])
    }
}
