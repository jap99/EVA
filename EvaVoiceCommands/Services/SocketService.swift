////
////  SocketService.swift
////  chatapp
////
////  Created by Javid Poornasir on 7/23/17.
////  Copyright © 2017 Javid Poornasir. All rights reserved.
////
//
//import Foundation
//import SocketIO
//
//class SocketService: NSObject {
//    
//    static let instance = SocketService()
//    
//    // need an init since it's an NSObject
//    override init() {
//        super.init()
//    }
//    
//    // create our socket and point it to our api url
////    var socket: SocketIOClient = SocketIOClient(manager: URL(string: BASE_URL)! as! SocketManagerSpec, nsp: "")
//    
//    
//    // establish connection between app and web server
//    func establishConnection() {
//     //   socket.connect()
//    }
//    
//    
//    func closeConnection() {
//       // socket.disconnect()
//    }
//    
//    
//    // add a channel; handle addition of channel of messages
//    // when something's being sent via web socket it's called an emit (emit from the app or API) -> server & vice versa
//    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
//        
//        socket.emit("newChannel", channelName, channelDescription)
//        completion(true)
//    }
//    
//    func getChannel(completion: @escaping CompletionHandler) {
//        // listening for an emit from the API back to the app
//        socket.on("channelCreated") { (dataArray, ack) in
//            // parse out the data array to create a new channel obj and append it to our channels array
//            guard let channelName = dataArray[0] as? String else { return }
//            guard let channelDesc = dataArray[1] as? String else { return }
//            guard let channelId = dataArray[2] as? String else { return }
//            
//            // create a new channel object
//            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
//            MessageService.instance.channels.append(newChannel)
//            completion(true)
//            
//        }
//    }
//    
//    
//    
////    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
////        let user = UserDataService.instance
////
////        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
////        completion(true)
////    }
//    
//}
//
