//
//  ViewController.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/24/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import AVFoundation
import Intents
import Speech
import Crashlytics

class ViewController: UIViewController {
    
    @IBOutlet weak var helpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    // MARK: PERMISSIONS
    
    // GET PERMISSIONS FOR FOLLOWING FRAMEWORKS
    // AVFoundation - Microphone
    // SiriKit - Siri
    // Speech - Transcription
    
    func requestSiriPermissions() {
        
        INPreferences.requestSiriAuthorization { (status) in
            print("PRINTING SIRI AUTH STATUS - STATUS: \(status)")
            DispatchQueue.main.async {
                if status == .authorized {
                    self.requestRecordPermissions()
                } else {
                    self.helpLabel.text = "Siri permission was declined; please enable it in settings then tap Continue again"
                }
            }
            
        }
    }
    
    func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermissions()
                } else {
                    self.helpLabel.text = "Recording permission was declined; please enable it in settings then tap Continue again"
                }
            }
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.authorizationComplete()
                } else {
                    self.helpLabel.text = "Transcribe permission was declined; please enable it in settings then tap Continue again"
                }
            }
        }
    }
    
    func authorizationComplete() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func requestPermissions(_ sender: Any) {
        requestSiriPermissions()
    }
    
}
