//
//  GifCollectionViewCell.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 01.05.2023.
//

import UIKit
import SwiftyGif

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
}

extension GifCollectionViewCell {
    func configure(withData data: Gif) {
        guard let url = data.url, let url = URL(string: url) else { return }
        contentView.layer.cornerRadius = 15
        imageView.setGifFromURL(url)
    }
}
