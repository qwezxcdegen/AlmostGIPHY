//
//  ViewController.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 30.04.2023.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    let networkManager = NetworkManager.shared
    var gifs: [Gif] = []
    var offset = -25
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        collectionView.collectionViewLayout = layout
        fetchTrendingGifs(withReload: true)
    }


    func fetchTrendingGifs(withReload: Bool) {
        offset += 25
        if withReload {
            networkManager.fetchTrendingGifsData(offset: offset) { gifsData in
                gifsData.gifs.forEach { self.gifs.append($0) }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else {
            networkManager.fetchTrendingGifsData(offset: offset) { gifsData in
                gifsData.gifs.forEach { self.gifs.append($0) }
                
            }
        }
    }
    
}


extension ViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Double(gifs[indexPath.item].heightInt) / Double(gifs[indexPath.item].widthInt) * Double(collectionView.frame.width / 2)
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(withData: gifs[indexPath.item])
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if gifs.count - indexPath.item == 17 {
            fetchTrendingGifs(withReload: true)
        }
    }
}
