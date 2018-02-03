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

// Google Maps Night Mode

let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"all\"," +
    "    \"elementType\": \"geometry\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#242f3e\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"all\"," +
    "    \"elementType\": \"labels.text.stroke\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"lightness\": -80" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"administrative\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#746855\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"administrative.locality\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#d59563\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"poi\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#d59563\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"poi.park\"," +
    "    \"elementType\": \"geometry\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#263c3f\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"poi.park\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#6b9a76\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road\"," +
    "    \"elementType\": \"geometry.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#2b3544\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#9ca5b3\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.arterial\"," +
    "    \"elementType\": \"geometry.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#38414e\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.arterial\"," +
    "    \"elementType\": \"geometry.stroke\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#212a37\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.highway\"," +
    "    \"elementType\": \"geometry.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#746855\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.highway\"," +
    "    \"elementType\": \"geometry.stroke\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#1f2835\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.highway\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#f3d19c\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.local\"," +
    "    \"elementType\": \"geometry.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#38414e\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"road.local\"," +
    "    \"elementType\": \"geometry.stroke\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#212a37\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit\"," +
    "    \"elementType\": \"geometry\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#2f3948\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"transit.station\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#d59563\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"water\"," +
    "    \"elementType\": \"geometry\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#17263c\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"water\"," +
    "    \"elementType\": \"labels.text.fill\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"color\": \"#515c6d\"" +
    "      }" +
    "    ]" +
    "  }," +
    "  {" +
    "    \"featureType\": \"water\"," +
    "    \"elementType\": \"labels.text.stroke\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"lightness\": -20" +
    "      }" +
    "    ]" +
    "  }" +
"]"


