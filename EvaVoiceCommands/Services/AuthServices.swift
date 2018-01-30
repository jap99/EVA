//
//  AuthServices.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

/*
import Foundation
import FirebaseAuth
import SwiftKeychainWrapper

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

var uid = Auth.auth().currentUser?.uid

class AuthService {
    
    var userdefaults: UserDefaults!
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                print("JAVID: Error logging in")
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                
            } else if let user = user {
                
                self.useKeychain(id: user.uid)
                onComplete?(nil, user)
                print("JAVID: User has successfully logged in")
                print("JAVID: Printing user.uid from login function - \(user.uid)")
                
                DataService.instance.saveOrUpdateDeviceToken(uid: user.uid, deviceToken: DEVICE_ID)
                
            }
        })
    }
    
    func createAccount(email: String, password: String, lastName: String, firstName: String, mobileNumber: String, isDriver: Bool, onComplete: Completion?) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                
            } else if let user = user {
                
                DataService.instance.saveUser(uid: user.uid, emailAddress: email, lastName: lastName, firstName: firstName, mobileNumber: mobileNumber, isDriver: isDriver)
                self.useKeychain(id: user.uid)
                
                onComplete?(nil, user)
            }
        })
    }
    
    func useKeychain(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JAVID: Data saved to keychain - Keychain Result: \(keychainResult)")
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .invalidEmail:
                onComplete?("Invalid username or password. Please try again.", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid username or password. Please try again.", nil)
                break
            case .userNotFound:
                onComplete?("Invalid username or password. Please try again.", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. This email address is already registered with an account.", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    
}
 
 */
