//
//  Constant+UI.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import UIKit

extension Constant {
    enum Color {
        static let label = UIColor.label
        static let background = UIColor.systemBackground
        static let groupedBackground = UIColor.systemGroupedBackground
        static let secondaryGroupedBackground = UIColor.secondarySystemGroupedBackground
        
        enum Button {
            static let valid = UIColor.systemBlue
            static let notValid = UIColor.systemGray
        }
        
        enum Label {
            static let valid = UIColor.systemGreen
            static let notValid = UIColor.systemRed
        }
    }
    
    enum Image {
        
        enum System {
            static let house = UIImage(systemName: "house")
            static let houseFill = UIImage(systemName: "house.fill")
            static let eyeSlash = UIImage(systemName: "eye.slash")
        }
    }
}
