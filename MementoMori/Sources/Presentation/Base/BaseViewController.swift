//
//  BaseViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    //MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
        bind()
    }
    
    //MARK: - Bind ViewController to ViewModel
    func bind() { }
    
    //MARK: - UI Configuration
    func configureUI() {
        view.backgroundColor = Constant.Color.background
    }
    
    //MARK: - Layouts
    func configureLayout() { }
}
