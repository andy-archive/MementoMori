//
//  SplashViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/14/23.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    //MARK: - Properties
    private let viewModel: SplashViewModel
    
    //MARK: - Initializer
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    //MARK: - Protocol Methods
    override func bind() {
        
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func configureLayout() {
        
    }
}
