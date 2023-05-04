//
//  GifCollectionViewCell.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 01.05.2023.
//

import UIKit
import SwiftyGif
import ShimmerSwift

final class GifCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var shimmeringView: ShimmeringView!
    
    // MARK: - Private Properties
    private var gifUrlSession: URLSessionDataTask?
    
    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        gifUrlSession?.cancel()
        shimmeringView.isShimmering = false
    }
    
    // MARK: - Public Methods
    func configure(withData data: Gif) {
        guard let url = data.url, let url = URL(string: url) else { return }
        
        loaderView.backgroundColor = .getRandomColor()
        shimmeringView.contentView = loaderView
        shimmeringView.isShimmering = true
        contentView.layer.cornerRadius = 8
        
        loadGifFrom(url: url)
    }
}

// MARK: - Private Methods
private extension GifCollectionViewCell {
    func loadGifFrom(url: URL) {
        imageView.clear()
        gifUrlSession?.cancel()
        gifUrlSession = imageView.setGifFromURL(url, showLoader: false)
    }
}
