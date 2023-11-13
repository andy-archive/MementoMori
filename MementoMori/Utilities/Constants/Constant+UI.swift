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
    }
    
    enum Image {
        
        enum System {
            static let house = UIImage(systemName: "house")
            static let houseFill = UIImage(systemName: "house.fill")
        }
    }
}