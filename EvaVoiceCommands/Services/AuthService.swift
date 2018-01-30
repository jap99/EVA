//
//  AuthService.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/19/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

var uid = Auth.auth().currentUser?.uid

class AuthService {
    
    static let instance = AuthService()
    
    // don't use for heavy data like images or secure data like passwords
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        } set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        } set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        } set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
                print(response.data as Any)
                print(response.debugDescription)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                //                if let json = response.result.value as? Dictionary<String, Any> {
                //                    if let email = json["user"] as? String {
                //                        self.userEmail = email
                //                    }
                //                    if let token = json["token"] as? String {
                //                        self.authToken = token
                //                    }
                //                }
                
                // Using SwiftyJSON instead
                
                guard let data = response.data else { return }
                do {
                
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    
                    self.isLoggedIn = true
                    completion(true)
                } catch {
                    print("AUTH ERROR #1")
                      completion(false)
                }
            } else {
                
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(name: String, email: String, completion: @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        let body: [String: Any] = [
            "email": lowerCaseEmail,
            "name": name,
        ]
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                
                completion(true)
                print(response.data as Any)
                print(response.debugDescription)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func findUserByEmail(completion: @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                
                completion(true)
                print(response.data as Any)
                print(response.debugDescription)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    func setUserInfo(data: Data) {
        
        do {
            let json = try JSON(data: data)
            let id = json["_id"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            
            UserDataService.instance.setUserData(id: id, email: email, name: name)
        } catch {
            print("AUTH ERROR #2")
        }
        
    }
    
}








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

