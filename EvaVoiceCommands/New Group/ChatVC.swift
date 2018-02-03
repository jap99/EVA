//
//  ChatVC.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import SwiftKeychainWrapper
import MapKit
import AVFoundation
import Intents
import Speech


class ChatVC: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate {

    // Menu button
    @IBOutlet weak var menuBtn: UIButton!
    
    // Permissions
    @IBOutlet weak var permissionsLabel: UILabel!
    @IBOutlet weak var permissionStackView: UIStackView!
    @IBOutlet weak var permissionsView: UIView!
    var recordingPermissionsAuthorized: Bool!
    var siriPermissionsAuthorized: Bool!
    var transcribePermissionsAuthorized: Bool!
    
    // Firebase
    var ref = DatabaseReference()
    
    // Google Maps Search Bar
    var searchResultsController: AutoCompleteSearchBar!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var showedUserLocation: Bool = false
    var isOnline: Bool = false
    
    // Geofire
    var geoFire: GeoFire!
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var loc : CLLocation? = nil
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    // Google Annotation Detail
    
    @IBOutlet var annotationDetails:UIView!
    @IBOutlet weak var orderImg: UIImageView!
    @IBOutlet weak var startToFinishLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bottomBar: UILabel!

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRevealVC()
        setupMap()
 //     setButtonStatus()
        setupKeychainWrapper()
//      setupIfAuthenticated()
//      self.updateMap()
 
        UIApplication.shared.statusBarStyle = .lightContent
        self.permissionsView.layer.cornerRadius = 6.0
        
        self.callPermissionFunctions {
            self.checkAllPermissions()
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.endEditing(true)
//      setButtonStatus()
//      setupIfAuthenticated()
//      self.updateMap()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    // MARK: - SETUP CODE
    
    func setupRevealVC() {
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    func setupMap() {
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: DataService.instance.mainRef.child("order-locations"))
        self.locationManager.delegate = self
        
        self.googleMapsView.delegate = self
        self.googleMapsView.mapType = GMSMapViewType.normal
        updateLocation(running: true)
        //annotationDetails.isHidden = true
        
        do {
            googleMapsView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            print("PRINTING - ONE OR MORE MAP STYLES FAILED TO LOAD. \(error)")
        }
        
        //self.view = googleMapsView
        
    }
    
    func setupKeychainWrapper() {
        if let keychainResult = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("JAVID: UID FOUND IN KEYCHAIN in StartingVC - Keychain Result: \(keychainResult)")  }
    }
    
  
    
    // MARK: - APPLE MAPS
    
    


  
    
    // MARK: - MAP FUNCTIONS
    
    func updateMap() {
        
        self.googleMapsView.clear()
        
        if self.loc != nil {
            
            print("PRINTING - SELF.LOC IS NOT NIL")
            
            //            if self.goOnlineButton.isSelected {
            self.showOrdersOnMap(location: self.loc!)
            //            } else {
            //                self.showUsersOnMap()
            //            }
        }
    }
    
    func updateLocation(running: Bool) {
        
        let status = CLLocationManager.authorizationStatus()
        
        if running {
            if (CLAuthorizationStatus.authorizedWhenInUse == status) {
                locationManager.startUpdatingLocation()
                
                googleMapsView.isMyLocationEnabled = true
            }
            
        } else {
            
            locationManager.stopUpdatingLocation()
            googleMapsView.settings.myLocationButton = false
            googleMapsView.isMyLocationEnabled = false
        }
    }
    
    
    func findLocationWithCoordinates(longitude: Double, latitude: Double, title: String) {
        
        DispatchQueue.main.async { () -> Void in
            
            let position = CLLocationCoordinate2DMake(latitude, longitude)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "JAVID ----- HomeVC --- Address is: \(title)"
            marker.map = self.googleMapsView
        }
    }
    
    
    // MARK: - MAPS - CORE LOCATION DELEGATES
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation

        if(!self.showedUserLocation) {
            self.showedUserLocation = true
            self.googleMapsView.camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: 10.0)

            self.loc = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

            updateMap()
        }
    }
    
    

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        // Called when location updates start to arrive
    }

    
  
    
    // MARK: - MAPS - GOOGLE MAP FUNCTIONS

    
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        // Shows the info view
//
//        marker.tracksInfoWindowChanges = true
//        if let infoMarker = marker as? OrderAnnotation {
//            if !infoMarker.isDriver { // set to false, therefore it's an order
//
//                //print(infoMarker.fromAndTo)
//                //print(infoMarker.nameOfGig)
//                //print(infoMarker.bottomBar)
//                orderImg.image = infoMarker.orderImg
//                startToFinishLbl.text = infoMarker.fromAndTo
//                titleLbl.text = infoMarker.nameOfGig
//                bottomBar.text = infoMarker.bottomBar
//                self.annotationDetails.isHidden = false
//                return annotationDetails
//            }
//        }
//        return nil
//    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//
//        if let infoMarker = marker as? OrderAnnotation {
//            if !infoMarker.isDriver {
//                let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                //  let vc: UINavigationController = sb.instantiateViewController(withIdentifier: "OrderDetailsNC-ID") as! UINavigationController
//                //  (vc.viewControllers.first as! OrderDetailsVC).orderKey = infoMarker.key
//                //  self.present(vc, animated: false, completion: nil)
//
//                let vc: OrderDetailsVC = sb.instantiateViewController(withIdentifier: "OrderDetailsVC-ID") as! OrderDetailsVC
//                vc.orderID = infoMarker.key
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - SHOW RIDES / ORDERS
    
    func showOrdersOnMap(location: CLLocation) {
        
        let query = geoFire!.query(at: location, withRadius: 100.0)
        _ = query?.observe(.keyEntered, with: { (key, location) in
            
            if let key = key, let location = location {
                
                let _ = Database.database().reference().child("orders").child(key).observe(.value) { (snapshot: DataSnapshot) in
                    //                        if !self.goOnlineButton.isSelected {
                    //                            return
                    //                        }
                    
                    DispatchQueue.main.async {
                        if let uploads = snapshot.value as? [String: AnyObject] {
                            if
                                let pickupObj = uploads["pickupLocation"] as? [String: AnyObject],
                                let dropoffObj = uploads["dropoffLocation"] as? [String: AnyObject],
                                let nameOfGig = uploads["nameOfGig"] as? String,
                                let img1 = uploads["image_1"] as? String,
                                let status = uploads["status"] as? String,
                                let priceEstimate = uploads["priceEstimate"] as? String,
                                let packageSize = uploads["packageSize"] as? String,
                                let estimatedDistanceInMiles = uploads["estimated_distance"] as? Double,
                                let priority = uploads["priority"] as? String
                            {
                                if let pickupAddress = pickupObj["pickupAddress"] as? String,  let dropoffAddress = dropoffObj["dropoffAddress"] as? String  {
                                    let pickupAddressComponent = pickupAddress.components(separatedBy: ",")
                                    let dropoffAddressComponent = dropoffAddress.components(separatedBy: ",")
                                    let status = status
                                    let marker = OrderAnnotation(position: location.coordinate)
                                    
                                    if status == "not_assigned" {
                                        marker.key = key
                                        marker.isDriver = false
                                        marker.nameOfGig = nameOfGig
                                        marker.icon = self.resizeImage(image: UIImage(named: "pickuppin")!, scaledToSize: CGSize(width: 30, height: 42))
                                        marker.map = self.googleMapsView
                                        if pickupAddressComponent.count >= 2 && dropoffAddressComponent.count >= 2 {
                                            marker.fromAndTo = "\(pickupAddressComponent[1]) -> \(dropoffAddressComponent[1])"
                                        }
                                    }
                                    DispatchQueue.global(qos: .background).async(execute: {
                                        do {
                                            if img1 != "" {
                                                let orderImageData = try Data(contentsOf: URL(string: img1)!)
                                                
                                                DispatchQueue.main.async(execute: {
                                                    if let orderImg: UIImage = UIImage(data: orderImageData) {
                                                        marker.orderImg = orderImg
                                                    }
                                                })
                                            }
                                            
                                            DispatchQueue.main.async(execute: {
                                                let bottomBar = "$\(priceEstimate)  \(priority) hours   \(estimatedDistanceInMiles) miles   \(packageSize.capitalizeFirst()) Size"
                                                marker.fromAndTo = "\(pickupAddressComponent[1]) -> \(dropoffAddressComponent[1])"
                                                marker.bottomBar = bottomBar
                                            })
                                        } catch {
                                            print("PRINTING - ERROR IN SHOWORDERSONMAP()")
                                        }
                                    })
                                }
                            }
                        }
                        
                    }
                    
                }
            }
        })
    }
    
    
    
    
    //    func showUsersOnMap() {
    //
    //        let _ = Database.database().reference().child("driver-locations").observe(.value) { (snapshot: DataSnapshot) in
    //
    //            if self.goOnlineButton.isSelected {
    //                return
    //            }
    //
    //            DispatchQueue.main.async {
    //
    //                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
    //                    let bounds = GMSCoordinateBounds()
    //                    for snap in snapshot {
    //
    //                        if let uploads = snap.value as? [String: AnyObject] {
    //                            if
    //                                let latitude = uploads["drivers_lat"] as? Double,
    //                                let longitude = uploads["drivers_lon"] as? Double,
    //                                let isUserOnline = uploads["isOnline"] as? Bool
    //                            {
    //                                if isUserOnline == true  {
    //                                    let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    //                                    let marker = GMSMarker(position: position)
    //                                    marker.icon = self.resizeImage(image: UIImage(named: "sherpa_map_pin")!, scaledToSize: CGSize(width: 30, height: 42))
    //                                    marker.map = self.googleMapsView
    //                                    bounds.includingCoordinate(position)
    //                                }
    //                            }
    //                        }
    //                    }
    //                    let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100)
    //                    self.googleMapsView.animate(with: cameraUpdate)
    //                }
    //            }
    //        }
    //    }
    //
    //
    
    // MARK: - GO ONLINE
    
    
    //    @IBAction func goOnline(_ sender: Any) {
    //
    //        //      DispatchQueue.global(qos: .background).async(execute: {
    //        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
    //
    //        self.latitude = self.googleMapsView.myLocation?.coordinate.latitude
    //        self.longitude = self.googleMapsView.myLocation?.coordinate.longitude
    //
    //        if (sender as! UIButton).isSelected {
    //
    //            DataService.instance.goOnline(uid: (uid)!, isOnline: true, lat: self.latitude, lon: self.longitude)
    //
    //            DispatchQueue.main.async {
    //                self.getAQuoteBtn.isHidden = true
    //                self.getAquoteStackView.isHidden = true
    //            }
    //            self.manageGoOnlineButton(isSelected: (sender as! UIButton).isSelected)
    //
    //        } else {
    
    //          // GO OFFLINE
    //
    //            DataService.instance.goOffline(uid: (uid)!)
    //
    //
    //            DispatchQueue.main.async {
    //                self.getAQuoteBtn.isHidden = false
    //                self.getAquoteStackView.isHidden = false
    //            }
    //            self.manageGoOnlineButton(isSelected: !(sender as! UIButton).isSelected)
    //        }
    //        //   })
    //    }
    //
    //
    //
    //
    //    func manageGoOnlineButton(isSelected: Bool) {
    //
    //        if goOnlineButton.isSelected {
    //            DispatchQueue.main.async {
    //
    //                self.goOnlineButton.backgroundColor = UIColor.white
    //                self.goOnlineButton.tintColor = UIColor.white
    //                self.goOnlineButton.setImage(UIImage(named: "Sherpaon"), for: .selected)
    //            }
    //
    //        } else {
    //            DispatchQueue.main.async {
    //                self.goOnlineButton.setImage(UIImage(named: "Sherpaoff"), for: .normal)
    //            }
    //        }
    //        DispatchQueue.main.async {
    //            self.goOnlineButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    //        }
    //        updateMap()
    //    }
    //
    
    // MARK: - ADDRESS SEARCH
    
    
    @IBAction func addressAutoComplete(_ sender: AnyObject) {
        //        let searchController = UISearchController(searchResultsController: searchResultsController)
        //        searchController.searchBar.delegate = self
        //        self.present(searchController, animated: true, completion: nil)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func setupIfAuthenticated() {
    //        if uid == nil {
    //            self.goOnlineButton.isHidden = true
    //            self.goOnlineButton.isSelected = false
    //            getAQuoteBtn.isHidden = false
    //            getAquoteStackView.isHidden = false
    //            showUsersOnMap()
    //            // setNavBarTitleSherpasNearYou()
    //
    //        } else {
    //            checkIfDriver()
    //        }
    //
    //    }
    //
    
    
    //
    //    func setNavBarTitleSherpasNearYou() {
    //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Nunito-Light", size: 17)!]
    //        navigationItem.title = "Sherpas Near You"
    //    }
    //
    //
    //
    //
    //
    //    func setNavBarTitleOrdersNearYou() {
    //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Nunito-Light", size: 17)!]
    //        navigationItem.title = "Orders Near You"
    //    }
    
    
    
    //    @IBAction func getQuoteBtnPressed(_ sender: Any) {
    //
    //        if uid != nil {
    //            latitude = googleMapsView.myLocation?.coordinate.latitude
    //            longitude = googleMapsView.myLocation?.coordinate.longitude
    //
    //            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //     //       let vc: CreateGigVC = sb.instantiateViewController(withIdentifier: "CreateGigVC-ID") as! CreateGigVC
    //     //       self.present(vc, animated: false, completion: nil)
    //
    //        } else {
    //            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    //            let vc: UINavigationController = sb.instantiateViewController(withIdentifier: "LoginNC-ID") as! UINavigationController
    //
    //            self.present(vc, animated: false, completion: nil)
    //            return
    //        }
    //
    //    }
    
    
    //
    //    func setButtonStatus() {
    //
    //        if let userID = uid {
    //
    //            DispatchQueue.main.async {
    //
    //                do {
    //                    let nc = try self.tabBarController?.viewControllers?[2] as? UINavigationController
    //                    nc?.popToRootViewController(animated: false)
    //                } catch {
    //                    print("error popping order's vc back to root view controller")
    //                }
    //
    //                let _ = self.ref.child("driver-locations").child(userID).observe(.value, with: { (snapshot1: DataSnapshot) in
    //
    //                    if let dict = snapshot1.value as? Dictionary<String, AnyObject> {
    //
    //                        if let isOnline =  dict["isOnline"] as? Bool {
    //
    //                            if isOnline == true {
    //
    //                                self.getAQuoteBtn.isHidden = true
    //                                if let loc = self.loc {
    //                                    self.showOrdersOnMap(location: loc)
    //                                }
    ////                                if let tabBar = self.tabBarController as? TabBarVC {
    ////                                    tabBar.updateTabBarColors(isOnline: true)
    ////                                }
    //                                navBarColor = UIColor.white
    //                                statusBarColor = UIColor.white
    //                                UIApplication.shared.statusBarStyle = .default
    //                                navTitleColor = UIColor.black
    //                                self.goOnlineButton.isSelected = true
    //                                self.goOnlineButton.setImage(UIImage(named: "Sherpaon"), for: .selected)
    //                                self.setNavigationBarColor()
    //                                self.goOnlineButton.backgroundColor = UIColor.clear
    //                                self.getAquoteStackView.isHidden = true
    //                      //          self.setNavBarTitleOrdersNearYou()
    //
    //                            } else if isOnline == false {
    //
    ////                                if let tabBar = self.tabBarController as? TabBarVC {
    ////                                    tabBar.updateTabBarColors(isOnline: false)
    ////                                }
    ////                                UIApplication.shared.statusBarStyle = .lightContent
    //                                navBarColor = Theme.primaryOrangeColor()
    //                                statusBarColor = Theme.dimPrimaryOrangeColor()
    //                                navTitleColor = UIColor.white
    //                                self.setNavigationBarColor()
    //                                self.goOnlineButton.setImage(UIImage(named: "Sherpaoff"), for: .normal)
    //                                self.goOnlineButton.backgroundColor = UIColor.clear
    //                                self.goOnlineButton.isSelected = false
    //                                self.getAQuoteBtn.isHidden = false
    //                                self.getAquoteStackView.isHidden = false
    //                                self.showUsersOnMap()
    //               //                 self.setNavBarTitleSherpasNearYou()
    //
    //                            }
    //                        }
    //
    //                    } else {  // If they get here it's because they're not a driver
    //
    ////                        if let tabBar = self.tabBarController as? TabBarVC {
    ////                            tabBar.updateTabBarColors(isOnline: false)
    ////                        }
    //                        navBarColor = Theme.primaryOrangeColor()
    //                        statusBarColor = Theme.dimPrimaryOrangeColor()
    //                        self.setNavigationBarColor()
    //                        self.goOnlineButton.isSelected = false
    //                        self.getAQuoteBtn.isHidden = false
    //                        self.getAquoteStackView.isHidden = false
    //                        self.showUsersOnMap()
    //         //               self.setNavBarTitleSherpasNearYou()
    //
    //                    }
    //
    //
    //                })
    //            }
    //        }
    //    }
    //
    //
    
    
    
    //    func checkIfDriver() {
    //
    //
    //        if let userID = uid {
    //
    //            self.ref.child(FIR_CHILD_USERS).child(userID).child("profile").observe(.value, with: { (snapshot1: DataSnapshot) in
    //
    //                if let dict = snapshot1.value as? Dictionary<String, AnyObject> {
    //                    if let isDriver =  dict["driver"] as? Bool {
    //                        if isDriver == true {
    //                            self.goOnlineButton.isHidden = false
    //                        } else {
    //                                 // not a driver
    //                            self.goOnlineButton.isSelected = false
    //                            self.showUsersOnMap()
    //                            self.goOnlineButton.isHidden = true
    //      //                      self.setNavBarTitleSherpasNearYou()
    //                        }
    //                    }
    //                }
    //            })
    //        }
    //
    //
    //    }
    //
    
    
    
    
    
    
    // MARK: - PERMISSIONS
    
    // GET PERMISSIONS FOR FOLLOWING FRAMEWORKS
    // AVFoundation - Microphone
    // SiriKit - Siri
    // Speech - Transcription
    
    
    func callPermissionFunctions(closure: () -> ()) {
        recordingPermissionsAuthorized = checkRecordingPermissions()
        siriPermissionsAuthorized = checkSiriPermissions()
        transcribePermissionsAuthorized = checkTranscribePermissions()
        closure()
    }
    
    
    // --- CHECK ALL PERMISSIONS ---
    
    func checkAllPermissions() {
        
        if recordingPermissionsAuthorized && siriPermissionsAuthorized && transcribePermissionsAuthorized  {
            self.permissionsView.isHidden = true
            
        } else {
            self.permissionsView.isHidden = false
        }
    }
    
    
    func checkRecordingPermissions() -> Bool {
        
        var recordingPermissionAuthorized = false
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            
            recordingPermissionAuthorized = true
        default:
            recordingPermissionAuthorized = false
            break
        }
        
        return recordingPermissionAuthorized
    }
    
    
    func checkSiriPermissions() -> Bool {
        let status = INPreferences.siriAuthorizationStatus().rawValue
        
        var siriPermissionAuthorized = false
        
        if status != 3 {
            siriPermissionAuthorized = false
            
        } else {
            siriPermissionAuthorized = true
            
        }
        
        return siriPermissionAuthorized
        
    }
    
    
    func checkTranscribePermissions() -> Bool {
        var transcribePermissionAuthorized = false
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            transcribePermissionAuthorized = true
            
        case .denied, .restricted, .notDetermined:
            transcribePermissionAuthorized = false
        }
        
        return transcribePermissionAuthorized
        
    }
    
    @IBAction func requestPermissions(_ sender: Any) {
        requestSiriPermissions()
        
    }
    
    // --- REQUEST PERMISSIONS ---
    
    func requestSiriPermissions() {
        self.permissionsView.isHidden = true
        if siriPermissionsAuthorized == false {
            
            INPreferences.requestSiriAuthorization { (status) in
                print("PRINTING SIRI AUTH STATUS - STATUS: \(status)")
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.requestRecordPermissions()
                        print("PRINTING - GOT SIRI PERMISSIONS")
                    } else {
                        self.permissionsLabel.text = "Siri permission declined; enable in settings."
                    }
                }
                
            }
        } else {
            
            self.requestRecordPermissions()
        }
        
    }
    
    func requestRecordPermissions() {
        
        if recordingPermissionsAuthorized == false {
            
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.requestTranscribePermissions()
                        print("PRINTING - GOT RECORDING PERMISSIONS")
                    } else {
                        self.permissionsLabel.text = "Recording permissions declined; enable them in settings."
                    }
                }
            }
        } else {
            
            self.requestTranscribePermissions()
        }
        
    }
    
    func requestTranscribePermissions() {
        
        if transcribePermissionsAuthorized == false {
            
            SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        self.authorizationComplete()
                        print("PRINTING - GOT TRANSCRIBE PERMISSIONS")
                    } else {
                        self.permissionsLabel.text = "Transcribe permission declined; enable them in settings."
                    }
                }
            }
        } else {
            
            self.authorizationComplete()
            
        }
        
    }
    
    func authorizationComplete() {
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    
}
