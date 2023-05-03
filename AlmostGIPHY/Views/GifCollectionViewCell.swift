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
    
    // TODO: - Comments
    // MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView! // weak
    @IBOutlet private var loaderView: UIView! // weak
    
    // MARK: - Private Properties
    private var gifUrlSession: URLSessionDataTask?
    private var shimmeringView: ShimmeringView?
    
    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        gifUrlSession?.cancel()
        // TODO: - Comments
        shimmeringView?.contentView = UIView() // Просто останови анимацию
    }
    
    // MARK: - Public Methods
    func configure(withData data: Gif) {
        guard let url = data.url, let url = URL(string: url) else { return }
        shimmeringView?.contentView = UIView()
        // TODO: - Comments
        loaderView.backgroundColor = getRandomColor() // Лучше вынести в расширение UIColor
        
        // Не нужно создавать эту вьюху постоянно, память протечет сильно
        // Она должна быть в единственном экземпляре и реюзаться
        // Закрепи ее с помощью констрэйнтов, чтобы не задавать вручную размер
        shimmeringView = ShimmeringView(frame: CGRect(x: 0, y: 0, width: data.widthInt, height: data.heightInt))
        shimmeringView?.backgroundColor = .white
        shimmeringView?.contentView = loaderView
        shimmeringView?.isShimmering = true
        
        // Ты и так знаешь, что вьюха существует, проверка лишняя
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
