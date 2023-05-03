//
//  NetworkManager.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 01.05.2023.
//

import UIKit

// TODO: - Comments
final class NetworkManager {
    static let shared = NetworkManager()
    // Ключ и урлы лучшк вынести в отдельный Constants файл
    let apiKey = "XQMCtCywjo6FEw8m9yftOBxIZP87Dn98"
    func fetchTrendingGifsData(offset: Int, completionHandler: @escaping (Gifs) -> Void) {
        guard let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=\(apiKey)&limit=25&offset=\(offset)&rating=g") else {
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            if let gifsData = self.parseJSON(withData: data) {
                completionHandler(gifsData)
            }
        }.resume()
    }
    
    private func parseJSON(withData data: Data) -> Gifs? {
        let decoder = JSONDecoder()
        do {
            let giphyResponseData = try decoder.decode(GiphyResponseData.self, from: data)
            guard let gifsData = Gifs(giphyResponseData: giphyResponseData) else { return nil }
            return gifsData
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    private init() {}
}

