//
//  GifData.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 01.05.2023.
//

// MARK: - Gifs
struct GiphyResponseData: Codable {
    let data: [GifData]
}

// MARK: - Datum
struct GifData: Codable {
    let url: String
    let username: String
    let source: String
    let title: String
    let images: Images
    let contentURL: String

    enum CodingKeys: String, CodingKey {
        case url
        case username, source, title
        case contentURL = "content_url"
        case images
    }
}

// TODO: - Comments
// Везде парсинг идет через строки, так делать не нужно
// MARK: - Images
struct Images: Codable {
    let original: FixedHeight
    let downsized, downsizedLarge, downsizedMedium: The480_WStill
    let downsizedSmall: The4_K
    let downsizedStill: The480_WStill
    let fixedHeight, fixedHeightDownsampled, fixedHeightSmall: FixedHeight
    let fixedHeightSmallStill, fixedHeightStill: The480_WStill
    let fixedWidth, fixedWidthDownsampled, fixedWidthSmall: FixedHeight
    let fixedWidthSmallStill, fixedWidthStill: The480_WStill
    let looping: Looping
    let originalStill: The480_WStill
    let originalMp4, preview: The4_K
    let previewGIF: The480_WStill
    let previewWebp: The480_WStill?
    let the480WStill: The480_WStill
    let hd, the4K: The4_K?

    enum CodingKeys: String, CodingKey {
        case original, downsized
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case downsizedStill = "downsized_still"
        case fixedHeight = "fixed_height"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightStill = "fixed_height_still"
        case fixedWidth = "fixed_width"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case originalStill = "original_still"
        case originalMp4 = "original_mp4"
        case preview
        case previewGIF = "preview_gif"
        case previewWebp = "preview_webp"
        case the480WStill = "480w_still"
        case hd
        case the4K = "4k"
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let height, width, size: String?
    let url: String?
}

// MARK: - The4_K
struct The4_K: Codable {
    let height, width, mp4Size: String?
    let mp4: String?

    enum CodingKeys: String, CodingKey {
        case height, width
        case mp4Size = "mp4_size"
        case mp4
    }
}

// TODO: - Comments
// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, width, size: String? // Почему это всё строки? Нужно сделать подходящие типы
    let url: String?
    let mp4Size: String?
    let mp4: String?
    let webpSize: String?
    let webp: String?
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames, hash
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4Size: String?
    let mp4: String?

    enum CodingKeys: String, CodingKey {
        case mp4Size = "mp4_size"
        case mp4
    }
}
