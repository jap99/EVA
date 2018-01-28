//
//  ChannelVC.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tv: UITableView!
    @IBAction func prepareForUnwindSegue(segue: UIStoryboardSegue){ }
    @IBOutlet weak var userImg: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tv.delegate = self; tv.dataSource = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        listenForNotif()
        
//        SocketService.instance.getChannel { (success) in
//            if success {
//                self.tv.reloadData()
//            }
//        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupUserInfo()
    }
    
    func listenForNotif() {
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        tv.reloadData()
    }
    
    @IBAction func addChannelBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.email, for: .normal)
            //loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            //userImg.image = UIImage(named: UserDataService.instance.avatarName)
            
            //userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tv.reloadData()
        }
    }

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tv.dequeueReusableCell(withIdentifier: "channelcell", for: indexPath) as? ChannelCell {
            
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when we select a row we're going to save the selected channel into our messageService variable selectedChannel; then notify the chatVC that we've selected a channel; then dismiss the menu
        
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        // shoot of notif that channel's been selected
        NotificationCenter.default.post(name: (NOTIF_CHANNEL_SELECTED), object: nil)
        
        // when we select an item, it closes
        self.revealViewController().revealToggle(animated: true)
        
        // now add an observer in chatVC
    }
    
    

}
