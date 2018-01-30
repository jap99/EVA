//
//  Constants.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/18/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// URL Constants
let BASE_URL = "https://chatappjp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"
let URL_GET_MESSAGES = "\(BASE_URL)message/byChannel"


// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)

// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
// contains  our auth token
let BEARER_HEADER =  [
//    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]


import Foundation

// Used for internal testing ---> sherpa-is-test
//let SERVERKEY = "AAAAQ1B8tBw:APA91bHbC8jQCieFjUj97TRDDeeekjlUa2468zwqip4XvfG1H3mmHMOlHKvzi4ggIE5Y0QsV4_k6VFXWTOWML-yIJjOeSDpzXlui5xNGYAqPEohOPdhmITyGPGk03sNuPp5mklVh-hI6d16cWz1xh2vq7oTrp74BAQ"


// FIREBASE
let SERVERKEY = "AAAAv1Y95EA:APA91bE3v3IgYQrK_KXiHpAlzIUzHHBgx6VHQwUWz-y8H9dWgIh4eQ82-HpW36N2dzSKAnocTWBl5_31G1Xm3PkQ34kljDZ0NRrm2oif010d-xQZoTd56DGD89O0Bs35S1h7KNGbBE7g"



var DEVICE_ID : String = ""

var navBarColor: UIColor = Theme.primaryOrangeColor()
var statusBarColor: UIColor = Theme.dimPrimaryOrangeColor()

var navTitleColor: UIColor = UIColor.white


