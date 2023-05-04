//
//  UIViewController + Extension.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 04.05.2023.
//

import UIKit

extension UIViewController {
    func presentDisappearableAlert(withTitle title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(ac, animated: true) { [unowned self] in
            self.dismiss(animated: true)
        }
    }
}
