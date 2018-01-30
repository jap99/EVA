//
//  OrderAnnotation.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import GoogleMapsCore
import GooglePlaces

class OrderAnnotation: GMSMarker {
    
    var nameOfGig: String = ""
    var key: String = ""
    var isDriver : Bool = false
    
    var orderImg: UIImage!
    var bottomBar: String = ""
    var fromAndTo: String = ""
    
    var pickupAddress: String = ""
    var dropoffAddress: String = ""
    
}




