//
//  Extensions.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func alertOK(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(alertAction)
        self.view.window?.rootViewController?.present(alertController, animated: true)
    }
}

extension Array where Element: Equatable {
    public func uniqueElements(in array: Array) -> Array {
        var uniqueArray = Array()
        array.forEach { element in
            if !uniqueArray.contains(element) {
                uniqueArray.append(element)
            }
        }
        return uniqueArray
    }
}
