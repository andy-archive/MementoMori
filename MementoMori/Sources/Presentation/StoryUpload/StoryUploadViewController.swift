//
//  StoryUploadViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

import RxSwift

final class StoryUploadViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = StoryUploadHeaderView()
    private lazy var photoItemView = UIView()
    private lazy var photoListView = UIView()
    
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
        let input = StoryUploadViewModel.Input(
            photoClickedInList: photoListView.rx.
        )
    }
    
    override func configureUI() {
        super.configureUI()
        
        //MARK: - UI Tests
        photoItemView.backgroundColor = .systemYellow.withAlphaComponent(0.4)
        photoListView.backgroundColor = .systemGray2
        
        //MARK: - View Hierarchies
        view.addSubview(headerView)
        view.addSubview(photoItemView)
        view.addSubview(photoListView)
    }
    
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
            photoItemView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        photoListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoListView.topAnchor.constraint(equalTo: photoItemView.bottomAnchor),
            photoListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
