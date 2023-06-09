//
//  GifDetailsViewController.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 02.05.2023.
//

import UIKit
import SwiftyGif

final class GifDetailsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Public Properties
    var gif: Gif!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = gif.fullGifUrl, let url = URL(string: url) {
            imageView.setGifFromURL(url)
        } else {
            imageView.image = UIImage(systemName: "exclamationmark.icloud.fill")
        }
    }
    
    // MARK: - IB Actions
    @IBAction private func socialNetworkPressed(_ sender: UIButton) {
        presentActivityVC()
    }
    
    @IBAction private func copyGifLinkPressed() {
        UIPasteboard.general.string = gif.fullGifUrl
        presentDisappearableAlert(withTitle: "GIF link has been copied")
    }
    
    @IBAction private func copyGifPressed() {
        guard let image = imageView.gifImage, let data = image.imageData else {
            presentDisappearableAlert(withTitle: "GIF is loading")
            return
        }
        
        UIPasteboard.general.setData(data, forPasteboardType: "com.compuserve.gif")
        presentDisappearableAlert(withTitle: "GIF has been copied")
    }
    
}

// MARK: - Private Methods
private extension GifDetailsViewController {
    // Activity VC
    func presentActivityVC() {
        guard let image = imageView.gifImage, let data = image.imageData else {
            presentDisappearableAlert(withTitle: "GIF is loading")
            return
        }
        
        let avc = UIActivityViewController(activityItems: [data as Any], applicationActivities: nil)
        avc.excludedActivityTypes = [.addToHomeScreen, .addToReadingList, .assignToContact, .collaborationCopyLink, .collaborationInviteWithLink, .markupAsPDF, .openInIBooks, .print, .sharePlay]
        
        present(avc, animated: true)
    }
}
