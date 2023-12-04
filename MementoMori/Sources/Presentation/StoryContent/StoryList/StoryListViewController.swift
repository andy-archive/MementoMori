//
//  StoryListViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryListViewController: BaseViewController {
    
    private lazy var headerView = StoryListHeaderView()
    private lazy var collectionView = StoryListCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() { }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(headerView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        StoryListViewController() // 📌 뷰컨마다 변경
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
