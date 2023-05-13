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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath) as? GifCollectionViewCell {
            cell.configure(withData: item)
            
            return cell
            
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell {
            
            cell.configure(withData: "TEST")
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
        
    }
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        snapshot.appendSections(["Categories", "Gifs"])
        snapshot.appendItems([Gif(url: "nil", width: "100", height: "100", fullGifUrl: "nil")], toSection: "Categories")
        snapshot.appendItems([Gif(url: "nil", width: "200", height: "500", fullGifUrl: "nil")], toSection: "Categories")
        snapshot.appendItems([Gif(url: "nil", width: "200", height: "100", fullGifUrl: "nil")], toSection: "Categories")
        snapshot.appendItems([Gif(url: "nil", width: "200", height: "400", fullGifUrl: "nil")], toSection: "Categories")
        dataSource.apply(snapshot)
        
//        let layout = CHTCollectionViewWaterfallLayout()
//        layout.minimumColumnSpacing = 5
//        layout.minimumInteritemSpacing = 5
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        collectionView.collectionViewLayout = layout
        
        let layout = createCompositionalLayout()
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
//extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
//        2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionViewLayout.collectionViewContentSize.width
//        let height = Double(gifs[indexPath.item].heightInt) / Double(gifs[indexPath.item].widthInt) * Double(width)
//        return CGSize(width: width, height: height)
//    }
//}

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
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let sections = ["Categories", "Gifs"]
            let section = sections[sectionIndex]
            switch section {
            case "Categories": return self.createCategoriesSection()
            case "Gifs": return self.createGifsSection()
            default: return self.createGifsSection()
            }
        }
        return layout
    }
    
    func createGifsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(collectionView.frame.width / 2 - 3), heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func createCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .estimated(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
