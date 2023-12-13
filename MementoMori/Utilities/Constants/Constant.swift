//
//  Constant.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/13.
//

import Foundation

enum Constant {
    
    enum Text {
        static let productID = "MementoMori"
    }
    
    enum FontSize {
        static let largeTitle: CGFloat = 30
        static let title: CGFloat = 18
        static let subtitle: CGFloat = 15
        static let body: CGFloat = 12
    }
    
    enum Layout {
        
        enum Common {
            
            enum Inset {
                static let horizontal: CGFloat = 20
                static let vertical: CGFloat = 20
            }
            enum Size {
                static let buttonHeight: CGFloat = 40
            }
        }
        
        enum StoryList {
            
            enum Header {
                static let height: CGFloat = 50
            }
        }
        
        enum StoryItem {
            enum Header {
                static let height: CGFloat = 50
                static let inset: CGFloat = 8
            }
            
            enum Footer {
                static let height: CGFloat = 40
                static let inset: CGFloat = 8
            }
        }
        
        enum UserAuth {
            
            enum Size {
                static let height: CGFloat = 50
            }
        }
    }
}
