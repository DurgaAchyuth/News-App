//
//  Utility.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import Foundation
import UIKit

struct Utility {
    
    public static func showAlert(sender: UIViewController, title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        sender.present(alertView, animated: true, completion: nil)
    }
    
    public static func convertDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
        let finalDate = dateFormatter.string(from: date!)
        return finalDate
    }
    
}
