//
//  UICollectionViewLayout+.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

extension UICollectionViewLayout {
    static func setCollectionViewLayout(
        numberOfItem: CGFloat,
        sectionSpacing: CGFloat,
        itemSpacing: CGFloat
    ) -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let numberOfItem: CGFloat = numberOfItem
        let sectionSpacing: CGFloat = sectionSpacing
        let itemSpacing: CGFloat = itemSpacing
        
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: sectionSpacing,
            bottom: 0,
            right: sectionSpacing
        )
        
        let size = UIScreen.main.bounds.width - sectionSpacing * 2 - itemSpacing * (numberOfItem - 1)
        
        layout.itemSize = CGSize(
            width: size / numberOfItem,
            height: size / numberOfItem
        )
        
        return layout
    }
}
