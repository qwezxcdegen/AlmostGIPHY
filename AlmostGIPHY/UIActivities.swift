//
//  UIActivities.swift
//  AlmostGIPHY
//
//  Created by Степан Фоминцев on 02.05.2023.
//

import UIKit

class TelegramActivity: UIActivity {
    override var activityType: UIActivity.ActivityType? {
        ActivityType(rawValue: "com.telegram.Telegram.Share")
    }
    override var activityTitle: String? {
        return "Telegram"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "whatsapp")
    }
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        true
    }
    
}
