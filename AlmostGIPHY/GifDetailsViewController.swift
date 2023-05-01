//
//  GifDetailsViewController.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 02.05.2023.
//

import UIKit
import SwiftyGif
import MessageUI

class GifDetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var gif: Gif!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = gif.fullGifUrl, let url = URL(string: url) {
            imageView.setGifFromURL(url)
        }
    }
    
    @IBAction func sharePressed(_ sender: UIBarButtonItem) {
        presentActivity()
    }
    
    
    @IBAction func socialNetworkPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0: presentActivityIM()
//        case 1:
//        case 2:
//        case 3:
//        case 4:
//        case 5:
//        case 6:
        default: break
        }
    }
    
    @IBAction func copyGifLinkPressed() {
        UIPasteboard.general.string = gif.fullGifUrl
        presentDisappearableAlert(withTitle: "GIF link has been copied")
    }
    
    @IBAction func copyGifPressed() {
        guard let image = imageView.gifImage, let data = image.imageData else {
            presentDisappearableAlert(withTitle: "GIF is loading")
            return
        }
        
        UIPasteboard.general.setData(data, forPasteboardType: "com.compuserve.gif")
        presentDisappearableAlert(withTitle: "GIF has been copied")
    }
    
}

extension GifDetailsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
        switch result {
        case .cancelled:
            presentDisappearableAlert(withTitle: "Cancelled")
        case .sent:
            presentDisappearableAlert(withTitle: "Sent")
        case .failed:
            presentDisappearableAlert(withTitle: "Failed")
        @unknown default:
            presentDisappearableAlert(withTitle: "Error")
        }
    }
    
    func presentDisappearableAlert(withTitle title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(ac, animated: true) { [unowned self] in
            self.dismiss(animated: true)
        }
    }
    
    func presentActivity() {
        guard let image = imageView.gifImage, let data = image.imageData else {
            presentDisappearableAlert(withTitle: "GIF is loading")
            return
        }
        let avc = UIActivityViewController(activityItems: [data as Any], applicationActivities: nil)
        present(avc, animated: true)
    }
    
    func presentActivityIM() {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        let messageVC = MFMessageComposeViewController()
        if let image = imageView.gifImage, let data = image.imageData {
            messageVC.addAttachmentData(data, typeIdentifier: "com.compuserve.gif", filename: "animated.gif")
        }
        messageVC.messageComposeDelegate = self
        
        present(messageVC, animated: true)
    }
}
