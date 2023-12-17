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
        static let secondaryLabel = UIColor.secondaryLabel
        static let background = UIColor.systemBackground
        static let groupedBackground = UIColor.systemGroupedBackground
        static let secondaryGroupedBackground = UIColor.secondarySystemGroupedBackground
        static let systemGray = UIColor.systemGray
        
        enum Button {
            static let valid = UIColor.systemBlue
            static let notValid = UIColor.systemGray
        }
        
        enum Label {
            static let valid = UIColor.systemGreen
            static let notValid = UIColor.systemRed
        }
        
        enum TextField {
            static let valid = UIColor.systemGreen
            static let notValid = UIColor.systemRed
        }
    }
    
    enum Image {
        
        enum System {
            static let house = UIImage(systemName: "house")
            static let houseFill = UIImage(systemName: "house.fill")
            static let eye = UIImage(systemName: "eye")?.withTintColor(.label.withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
            static let eyeSlash = UIImage(systemName: "eye.slash")?.withTintColor(.label.withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
            static let personTwo = UIImage(systemName: "person.2")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let star = UIImage(systemName: "star")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let heart = UIImage(systemName: "heart")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let bubbleTwo = UIImage(systemName: "bubble.left")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let paperplane = UIImage(systemName: "paperplane")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let ellipsis = UIImage(systemName: "ellipsis")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let bookmark = UIImage(systemName: "bookmark")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let plusSquare = UIImage(systemName: "plus.square")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let plusSquareFill = UIImage(systemName: "plus.square.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let xMark = UIImage(systemName: "xmark")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let chevronLeft = UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            static let arrowUp = UIImage(systemName: "arrow.up.circle")?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal)
        }
    }
}
