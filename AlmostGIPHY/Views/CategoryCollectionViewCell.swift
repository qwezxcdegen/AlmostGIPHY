//
//  CategoryCollectionViewCell.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 13.05.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configure(withData data: String) {
        categoryLabel.text = data
    }
}
