//
//  StoryListViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/28/23.
//

import UIKit

final class StoryListViewController: BaseViewController {
    
    private lazy var listHeaderView = StoryListHeaderView()
    private lazy var collectionView = StoryListCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() { }
    
    override func configureUI() {
        super.configureUI()
        
        view.addSubview(listHeaderView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        listHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listHeaderView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: listHeaderView.bottomAnchor),
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
