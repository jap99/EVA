//
//  Channel.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/23/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation

struct Channel: Decodable { // in order to parse in swift 4 manner must conform to Decodable protocol & our model must mirror exactly what we see in our json response
    
    // Swift 4
    //    public private(set) var _id: String!
    //    public private(set) var name: String!
    //    public private(set) var description: String!
    //    public private(set) var __v: Int?
    //
    
    public private(set) var channelTitle: String!
    public private(set) var channelDescription: String!
    public private(set) var id: String!
}

