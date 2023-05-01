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
        gifs = giphyResponseData.data.map { Gif(url: $0.images.fixedWidth.url, width: $0.images.fixedWidth.width, height: $0.images.fixedWidth.height) }
    }
}

struct Gif {
    let url: String?
    let width: String?
    let height: String?

    
    var widthInt: Int {
        guard let width, let width = Int(width) else { return 0 }
        return width
    }
    
    var heightInt: Int {
        guard let height, let height = Int(height) else { return 0 }
        return height
    }
}
