//
//  UserDataService.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/19/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    // Create a public getter variable that other classes are able to get
    // It's private because other classes cannot set the var
    public private(set) var id = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, email: String, name: String) {
        
        self.id = id
        self.email = email
        self.name = name
    }
    
    
    func returnUIColor(components: String) -> UIColor {
        
        // extract the values from mLab and convert to RGBA; we'll introduce a scanner to do so
        
        let scanner = Scanner(string: components)
        
        // first tell it which characters to skip
        let skipped = CharacterSet(charactersIn: "[], ") // those are the 4 variables we want skipped
        
        // scan up to the comma, which is the variable common amongst all the components
        let comma = CharacterSet(charactersIn: ",")
        
        scanner.charactersToBeSkipped = skipped
        
        // save the variables
        var r, g, b, a: NSString?
        
        // start scanning
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        // need to convert to CGFloat; will do String -> Double -> CGFloat
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
    }
    
    
    func logoutUser() {
        id = ""
        email = ""
        name = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
        MessageService.instance.clearChannels()
    }
    
}

