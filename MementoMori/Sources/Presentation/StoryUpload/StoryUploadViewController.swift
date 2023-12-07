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
    
    //MARK: - Properties
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
        
        view.addSubview(headerView)
    }
    
    override func configureLayout() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constant.Layout.StoryList.Header.height)
        ])
    }
}

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        StoryUploadViewController() // 📌 뷰컨마다 변경
    }
    
    func updateUIViewController(_ uiView: UIViewController,context: Context) {
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
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
