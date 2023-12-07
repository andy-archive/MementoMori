//
//  StoryUploadViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/7/23.
//

import UIKit

final class StoryUploadViewController: BaseViewController {
    
    //MARK: - UI
    private lazy var headerView = StoryUploadHeaderView()
    private lazy var photoItemView = UIView()
    private lazy var photoListView = UIView()
    
    //MARK: - ImagePickerController
    private let imagePicker = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
    }
    
    override init() {
        super.init()
        
        self.imagePicker.delegate = self
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

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        StoryUploadViewController()
    }
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
    }
}

struct ViewController_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            Preview()
                .previewDisplayName("Preview")
        }
    }
}
#endif
