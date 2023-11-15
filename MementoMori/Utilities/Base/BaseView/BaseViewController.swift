//
//  BaseViewController.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureLayout()
    }
    
    func configureUI() {
        view.backgroundColor = Constant.Color.background
    }
    
    func configureLayout() { }
}

