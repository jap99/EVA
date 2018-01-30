//
//  AutoCompleteController.swift
//  EvaVoiceCommands
//
//  Created by Javid Poornasir on 1/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit


protocol AutoCompleteToAnnotation{
    // Drop a pin on the map from the lat and long that's taken from the search bar
    
    // title = title of address's location
    func findLocationWithCoordinates(longitude: Double, latitude: Double, title: String)
}

class AutoCompleteSearchBar: UITableViewController {
    
    var searchResultsArray: [String]!
    var delegate: AutoCompleteToAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchResultsArray = Array()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResultsArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.searchResultsArray[indexPath.row]
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath){
        
        self.dismiss(animated: true, completion: nil)
        
        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResultsArray[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            
            do {
                if data != nil{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    let latitude =   (((((dict.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
                    
                    let longitude =   (((((dict.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
                    
                    self.delegate.findLocationWithCoordinates(longitude: longitude, latitude: latitude, title: self.searchResultsArray[indexPath.row])
                }
                
            }catch {
                print("JAVID ---------------- Error in AutoCompleteController.swift file")
            }
        }
        
        task.resume()
    }
    
    
    func reloadDataWithArray(_ array:[String]){
        self.searchResultsArray = array
        self.tableView.reloadData()
    }
}

