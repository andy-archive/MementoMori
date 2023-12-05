//
//  UICollectionViewLayout+.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/3/23.
//

import UIKit

extension UICollectionViewLayout {
    static func configureFlowLayout(
        numberOfItemInRow: CGFloat,
        sectionSpacing: CGFloat,
        itemSpacing: CGFloat,
        scrollDirection: UICollectionView.ScrollDirection
    ) -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: sectionSpacing,
            bottom: 0,
            right: sectionSpacing
        )
        
        let size = UIScreen.main.bounds.width - sectionSpacing * 2 - itemSpacing * (numberOfItemInRow - 1)
        
        layout.itemSize = CGSize(
            width: size / numberOfItemInRow,
            height: size / numberOfItemInRow
        )
        
        return layout
    }
}
