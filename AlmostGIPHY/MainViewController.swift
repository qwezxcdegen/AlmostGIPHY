//
//  ViewController.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 30.04.2023.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class MainViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    let networkManager = NetworkManager.shared
    var gifs: [Gif] = []
    var offset = -25
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = layout
        fetchTrendingGifs(withReload: true)
    }
    
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        
    }
    
    func fetchTrendingGifs(withReload: Bool) {
        offset += 25
        if withReload {
            networkManager.fetchTrendingGifsData(offset: offset) { [weak self] gifsData in
                gifsData.gifs.forEach { self?.gifs.append($0) }
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        } else {
            networkManager.fetchTrendingGifsData(offset: offset) { gifsData in
                gifsData.gifs.forEach { self.gifs.append($0) }
                
            }
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GifDetailsViewController else { return }
        guard let gif = sender as? Gif else { return }
        vc.gif = gif
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(withData: gifs[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gifDetails", sender: gifs[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if gifs.count - indexPath.item == 17 {
            self.fetchTrendingGifs(withReload: true)
        }
    }
}

// MARK: - CHTCollectionViewDelegateWaterfallLayout
extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewLayout.collectionViewContentSize.width
        let height = Double(gifs[indexPath.item].heightInt) / Double(gifs[indexPath.item].widthInt) * Double(width)
        return CGSize(width: width, height: height)
    }
}
