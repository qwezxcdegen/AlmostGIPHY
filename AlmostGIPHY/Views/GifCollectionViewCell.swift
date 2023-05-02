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
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var loaderView: UIView!
    
    // MARK: - Private Properties
    private var gifUrlSession: URLSessionDataTask?
    private var shimmeringView: ShimmeringView?
    
    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        gifUrlSession?.cancel()
        shimmeringView?.contentView = UIView()
    }
    
    // MARK: - Public Methods
    func configure(withData data: Gif) {
        guard let url = data.url, let url = URL(string: url) else { return }
        shimmeringView?.contentView = UIView()
        loaderView.backgroundColor = getRandomColor()
        
        shimmeringView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: data.widthInt, height: data.heightInt))
        shimmeringView?.backgroundColor = .white
        shimmeringView?.contentView = loaderView
        shimmeringView?.isShimmering = true
        if let shimmeringView {
            contentView.addSubview(shimmeringView)
            contentView.addSubview(imageView)
        }
        
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
    
    func getRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
