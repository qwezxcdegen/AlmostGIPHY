//
//  UIColor + Extension.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 04.05.2023.
//

import UIKit

extension UIColor {
    static func getRandomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
