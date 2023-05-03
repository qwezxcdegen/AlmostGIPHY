//
//  GifsData.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 01.05.2023.
//

import UIKit
import SwiftyGif

struct Gifs {
    let gifs: [Gif]
    
    init?(giphyResponseData: GiphyResponseData) {
        gifs = giphyResponseData.data.map { Gif(url: $0.images.fixedWidth.url, width: $0.images.fixedWidth.width, height: $0.images.fixedWidth.height, fullGifUrl: $0.images.original.url) }
        
        // TODO: - Comments
        // Думаю, что у Images можно написать вычисляемое свойство, которое будет
        // само создавать и отдавать Gif
        // Структура не должна называться множественным числом Images
    }
}

struct Gif: Hashable {
    let url: String?
    let width: String?
    let height: String?
    let fullGifUrl: String?

    
    var widthInt: Int {
        guard let width, let width = Int(width) else { return 0 }
        return width
    }
    
    var heightInt: Int {
        guard let height, let height = Int(height) else { return 0 }
        return height
    }
}
