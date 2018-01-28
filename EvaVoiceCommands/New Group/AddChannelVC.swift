//
//  AddChannelVC.swift
//  chatapp
//
//  Created by Javid Poornasir on 7/23/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameTtx: UITextField!
    @IBOutlet weak var chanDesc: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTtx.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
        
        chanDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor:smackPurplePlaceholder])
    }
    
    
    @IBAction func createChannelBtnPressed(_ sender: Any) {
        guard let channelName = nameTtx.text, nameTtx.text != "" else { return }
        guard let channelDesc = chanDesc.text else { return }
        
//        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDesc) { (success) in
//            if success {
//                // dismiss modal
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

