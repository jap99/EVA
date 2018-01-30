//
//  DataService.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

let FIR_CHILD_USERS = "users"

import Foundation
import FirebaseDatabase

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    func saveUser(uid: String, emailAddress: String, lastName: String, firstName: String, mobileNumber: String, isDriver: Bool) {
        
        let createProfile: Dictionary<String, AnyObject> = [
            "email": emailAddress.capitalizeFirst() as AnyObject,
            "uid": uid as AnyObject,
            "driver": false as AnyObject,
            "lastName": lastName.capitalizeFirst() as AnyObject,
            "firstName": firstName.capitalizeFirst() as AnyObject,
            "phoneNumber": mobileNumber as AnyObject,
            "acceptedTOS": true as AnyObject,
            "isProfileCompleted": false as AnyObject
        ]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").updateChildValues(createProfile)
    }
    
    
    func goOnline(uid: String, isOnline: Bool, lat: Double, lon: Double) {
        
        if isOnline == true {
            let isOnline: Dictionary<String, AnyObject> = [
                "isOnline": true as AnyObject,
                "drivers_lat": lat as AnyObject,
                "drivers_lon": lon as AnyObject
            ]
            mainRef.child("driver-locations").child(uid).updateChildValues(isOnline)
        }
    }
    
    
    func goOffline(uid: String) {
        let isOnline: Dictionary<String, AnyObject> = [
            "isOnline": false as AnyObject
        ]
        mainRef.child("driver-locations").child(uid).updateChildValues(isOnline)
        mainRef.child("driver-locations").child(uid).child("drivers_lat").removeValue()
        mainRef.child("driver-locations").child(uid).child("drivers_lon").removeValue()
    }
    
    
    func setOrderStatus(orderID: String, uid: String, status: String, completionHandler : @escaping (_ error: Bool) -> ()) {
        let orderStatus: Dictionary<String, AnyObject> = [
            "status": status as AnyObject,
            "uid": uid as AnyObject
        ]
        mainRef.child("orders").child(orderID).updateChildValues(orderStatus) { (err, ref) in
            if err != nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    
    // Screen 1 of 3 in "Register As Sherpa"
    func addDriverDataToFirebase(uid: String, value: [String: AnyObject]) {
        
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").updateChildValues(value) { (err, ref) in
            
            if err != nil {
                let error = err
                print("ERROR UPDATING IMAGE FIELD IN DATABASE --- ERROR DESCRIPTION: \(error.debugDescription)")
                return
            }
        }
        
        let isOnline: Dictionary<String, AnyObject> = [
            "isOnline": false as AnyObject
        ]
        
        mainRef.child("driver-locations").child(uid).updateChildValues(isOnline) { (error, response) in
            if error != nil {
                print("Error setting driver in driver-locations node")
            } else {
                print("Successfully added driver to driver-locations node")
            }
        }
    }
    
    
    
    
    func saveProfileData(uid: String, firstName: String, lastName: String, phoneNumber: String, email: String) {
        
        let profile: Dictionary<String, AnyObject> = [
            "firstName": firstName.capitalizeFirst() as AnyObject,
            "lastName": lastName.capitalizeFirst() as AnyObject,
            "phoneNumber": phoneNumber as AnyObject,
            "email": email.capitalizeFirst() as AnyObject
        ]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").updateChildValues(profile)
    }
    
    
    func saveCustomerData(uid: String, customerId: String, firstName: String, lastName: String, address: String, city: String, state: String, zip: String, last4DigitCC : String, payment_method_token: String) {
        
        let cc: Dictionary<String, AnyObject> = [
            "firstName": firstName.capitalizeFirst() as AnyObject,
            "lastName": lastName.capitalizeFirst() as AnyObject,
            "address" : address as AnyObject,
            "city" : city.capitalizeFirst() as AnyObject,
            "state" : state as AnyObject,
            "zip" : zip as AnyObject,
            "creditcard_no" : last4DigitCC as AnyObject,
            "payment_method_token": payment_method_token as AnyObject
        ]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("creditcard-data").child(customerId).setValue(cc)
    }
    
    
    
    func saveOrUpdateDeviceToken(uid: String, deviceToken: String) {
        let profile: Dictionary<String, AnyObject> = [
            "deviceToken": deviceToken as AnyObject
        ]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").updateChildValues(profile)
    }
    
    
    
    func postBraintreeTransactionResultsToFirebase(order_ID: String, txn_ID: String, txn_Date: String, txn_Status: String) {
        
        let txnDetails: Dictionary<String, AnyObject> = [
            "txn_ID": txn_ID as AnyObject,
            "txn_Date": txn_Date as AnyObject,
            "txn_Status": txn_Status as AnyObject
        ]
        let txn = [order_ID : txnDetails]
        mainRef.child("txn").updateChildValues(txn)
    }
    
    
    func removeDriversUIDfromOrderAndAddToCancellationsNode(orderID: String, uid: String) {
        
        let cancellation = ["timeStamp" : "time when user cancels order"]
        
        mainRef.child("driver-cancellations").child(uid).child(orderID).updateChildValues(cancellation) { (error , ref ) in
            if (error != nil) {
                // Error occurred
            } else {
                print("Successfully added order to list of driver's cancellations")
            }
        }
        
        mainRef.child("orders").child(orderID).child("uid").removeValue { (error , ref) in
            if let err = error { print("An error occurred when attempting to remove the driver's uid from the order. Try again. error result --> \(err)")
            } else { print("Successfully removed the driver's uid from the order") }}
    }
    
    
    
}


