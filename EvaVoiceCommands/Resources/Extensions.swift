//
//  Extensions.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import FirebaseStorage


let KEY_UID = "uid"
var isDriver = false

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension NSDate {
    
    class func getPresentDate() -> NSString {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
        let stringDate = dateFormatter.string(from: date) as NSString
        
        return stringDate
    }
}

extension String {
    func capitalizeFirst() -> String {
        let firstIndex = self.index(startIndex, offsetBy: 1)
        return self.substring(to: firstIndex).capitalized + self.substring(from: firstIndex).lowercased()
    }
}

extension UIImageView {
    
    
    func load_image_from_firebase(imageURL: String) {
        
        // if cache != nil load from cache
        
        //    } else {
        
        let ref = Storage.storage().reference(forURL: imageURL)
        
        ref.getData(maxSize: Int64(2 * 1024 * 1024), completion: { (data, error) in
            
            if error != nil {
                
            } else {
                
                if let imgData = data {
                    
                    if let img = UIImage(data: imgData) {
                        self.image = img
                        
                        // set the cache for the imageURL
                    }
                }
            }
        })
    }
    //  }
    
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}


extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}


