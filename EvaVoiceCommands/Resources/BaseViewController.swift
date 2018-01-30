//
//  BaseViewController.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarColor()
    }
    
    
    func setNavigationBarColor() {
        self.navigationController?.navigationBar.barTintColor = navBarColor
        UIApplication.shared.statusBarView?.backgroundColor = statusBarColor
        self.navigationController?.navigationBar.isTranslucent = false
       // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: navTitleColor, NSFontAttributeName: UIFont(name: "Nunito-Light", size: 17)!]
        
        
    }
    
    
    
    func resizeImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let resizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
