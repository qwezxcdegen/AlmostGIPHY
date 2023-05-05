//
//  ViewController.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 30.04.2023.
//

import UIKit
import CHTCollectionViewWaterfallLayout

final class MainViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private var gifs: [Gif] = []
    private var offset = -25
    private var snapshot = NSDiffableDataSourceSnapshot<String, Gif>() {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                dataSource.apply(snapshot)
            }
        }
    }
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<String, Gif>(collectionView: collectionView) { collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(withData: item)
        
        return cell
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        snapshot.appendSections(["Gifs"])
        snapshot.appendSections(["Categories"])
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = layout
        
        fetchTrendingGifs()
    }
    
    // MARK: - IB Actions
    @IBAction func unwind(for segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GifDetailsViewController else { return }
        guard let gif = sender as? Gif else { return }
        vc.gif = gif
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if gifs.count - indexPath.item == 22 {
            fetchTrendingGifs()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gifDetails", sender: gifs[indexPath.item])
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

// MARK: - Private Methods
private extension MainViewController {
    func fetchTrendingGifs() {
        offset += 25
        networkManager.fetchTrendingGifsData(offset: offset) { [unowned self] gifsData in
            gifsData.gifs.forEach {
                gifs.append($0)
            }
            snapshot.appendItems(gifsData.gifs, toSection: "Gifs")
        }
    }
}
