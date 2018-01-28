//
//  IntentHandler.swift
//  EvaVoiceCommands-Intents
//
//  Created by Javid Poornasir on 1/24/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Intents


class IntentHandler: INExtension, INRidesharingDomainHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    


// MARK: REQUEST RIDE

    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        // Handles which ride was selected
        
        // We can't directly access which type of ride it was
        
        // APP GROUPING - used to pass data from your extension to your application & vice versa
        // APP GROUPING - it's enabled into the App ID of the application
        // APP GROUP = com.cleandev.SiriKit-EvaRideshare
        
        // WE CAN'T USE THE SAME BUNDLE IDENTIFIERS FOR THE EXTENSION AS THE PARENT BUNDLE
        // WE NEED TWO PROVISIONING PROFILES AND TWO APP ID'S
        
        
        // FIND OUT WHERE DRIVER IS AND HOW MUCH LONGER
        let status = INRideStatus()
        
        // Configure the ride request internally and get its ID
        status.rideIdentifier = self.createNewRideRequest(withStartingLocation: intent.pickupLocation!, endingLocation: intent.dropOffLocation!, partySize: intent.partySize!, paymentMethod: intent.paymentMethod!)
        
        // Configure the pickup and dropoff information.
        status.estimatedPickupDate = self.estimatedPickupDateForRideRequest(identifier: status.rideIdentifier!)
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        
        // Retrieve the ride details that the user needs.
        status.vehicle = self.vehicleForRideRequest(identifier: status.rideIdentifier!)
        status.driver = self.driverForRideRequest(identifier: status.rideIdentifier!)
        
        // Configure the vehicle type and pricing
        status.rideOption = self.rideOptionForRideRequest(identifier: status.rideIdentifier!)
        
        // Commit the request and get the current status
        status.phase = self.completeBookingForRideRequest(identifier: status.rideIdentifier!)
        
        var responseCode: INRequestRideIntentResponseCode
        if status.phase == .received {
            responseCode = .inProgress
        } else if status.phase == .confirmed {
            responseCode = .success
        } else {
            responseCode = .failure // There are many others we should handle also
        }
        
        let response = INRequestRideIntentResponse.init(code: responseCode, userActivity: nil)
        response.rideStatus = status
        
        let userDefaults: UserDefaults = UserDefaults.init(suiteName: "group.com.cleandev.SiriKit-EvaRideshare")!
        userDefaults.set(response.rideStatus?.description, forKey: "SelectedRide") // We'll use this key to fetch it in AppDelegate
        
        completion(response)
        
        // Handler should confirm the request and create an INRequestRideIntentResponse object about whether the ride was booked successfully
        
    }
    
    
    
    
    func confirm(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
    }
    
    
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        // Finds out if we have enough info to pickup at this location
        
        // Talk to server and get intent to find out location of ride
    }
    
    
    
    func resolveDropOffLocation(for intent: INListRideOptionsIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        // Finds out if we have enough info to dropoff to this location
        
        // Talk to server and get intent to find out location of ride
    }
    
    
    



// MARK: LIST RIDE OPTIONS

    
    func handle(intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        
        // Our intent just sends back the list of available cars and Maps does the rest
        
        let resp: INListRideOptionsIntentResponse = INListRideOptionsIntentResponse(code: .success, userActivity: nil)
        
        let ride1: INRideOption = INRideOption(name: "Toyota Prius", estimatedPickupDate: NSDate.init(timeIntervalSinceNow: 1000) as Date)
        ride1.priceRange = INPriceRange.init(price: 10.0, currencyCode: "USD")
        
        let ride2: INRideOption = INRideOption(name: "Honda Civic", estimatedPickupDate: NSDate.init(timeIntervalSinceNow: 440) as Date)
        ride2.priceRange = INPriceRange.init(price: 10.0, currencyCode: "USD")
        
        let ride3: INRideOption = INRideOption(name: "Toyota Tacoma", estimatedPickupDate: NSDate.init(timeIntervalSinceNow: 290) as Date)
        ride3.priceRange = INPriceRange.init(price: 10.0, currencyCode: "USD")
        
        let ride4: INRideOption = INRideOption(name: "Chevy Silverado", estimatedPickupDate: NSDate.init(timeIntervalSinceNow: 900) as Date)
        ride4.priceRange = INPriceRange.init(price: 10.0, currencyCode: "USD")
        ride4.disclaimerMessage = "This is bad for the environment"
        
        resp.expirationDate = Date(timeIntervalSinceNow: 3600)
        resp.rideOptions = [ride1, ride2, ride3, ride4]
        
        completion(resp)
    }
    



// MARK: GET RIDE STATUS


    
    var observer: INGetRideStatusIntentResponseObserver
    var timer: Timer
    
    func handle(intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        // Method gets called when user asks where their ride is
        
        // Get current location of ride then send back but we can't do that here
        
        if let result = INGetRideStatusIntentResponse(code: .success, userActivity: nil) {
            // code could also be in progress, failure, failure requring app launch, etc
            // user activity is set to app if user requests to launch the app to get more info then we might send the booking ID in there so the app can pickup where the extension left off
        completion(result)
        }
    }
    
    
    func startSendingUpdates(for intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
        // Maps calls this method only once. Your implementation must set up a timer or other repeating task to generate status updates for the ride and deliver them to the provided observer object. Maps uses your updates to keep the user informed about the ride’s location and estimated arrival time.
        
        // Save a reference to the observer object
        self.observer = observer
        
        // Set up time on main thread and save a reference to it
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                let rideStatus = INRideStatus()
                
                // Configure INRideStatus object
                
                //Create the response and deliver it
                let response = INGetRideStatusIntentResponse(code: .success, userActivity: nil)
                response.rideStatus = rideStatus
                
                // Handle cases where the server doesn't respond or returns an error - ie. might return a cached response if server doesn't respond in a timely manner. If you deliver an invalid response object to the observer, Maps calls the stopSendingUpdates(for:) of handler object and notifies user that a problem occurred.
                self.observer?.didUpdate(getRideStatus: response) // Call didUpdate when we have updated info about the ride
                
                // Provide updates when the ride phase or completion status changes - provide an udpate when vehicle is approaching pickup location or arrives at it
            })
        }
    }
    
    
    func stopSendingUpdates(for intent: INGetRideStatusIntent) {
        // Upon completion of ride and after charges have settled
        self.observer = nil
        self.timer?.invalidate()
        
        // Clean up any other state information
    }




// MARK: CANCEL RIDE
 
    
    func handle(cancelRide intent: INCancelRideIntent, completion: @escaping (INCancelRideIntentResponse) -> Void) {
        
    }



// MARK: SEND RIDE FEEDBACK
    
    func handle(sendRideFeedback sendRideFeedbackintent: INSendRideFeedbackIntent, completion: @escaping (INSendRideFeedbackIntentResponse) -> Void) {
        
    }



}
















/*
// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}

*/

