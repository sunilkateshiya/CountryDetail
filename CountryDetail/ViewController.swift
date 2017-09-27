//
//  ViewController.swift
//  CountryDetail
//
//  Created by Kateshiya Sunil on 9/22/17.
//  Copyright © 2017 Kateshiya Sunil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mylable: UILabel!
    
    @IBOutlet weak var myTable: UITableView!
    
    
    
    var featchCountry = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.dataSource = self
        
        parcedata()
        searchBar()
    }
    
    func searchBar() {
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.scopeButtonTitles = ["Country"]
        self.myTable.tableHeaderView = searchBar
    }
    
    
    func parcedata() {
        featchCountry = []
        
        let url = "http://restcountries.eu/rest/v1/all"
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        
        let configration = URLSessionConfiguration.default
        let session = URLSession(configuration: configration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, responce, error) in
            if (error != nil) {
                print("Error")
            }
            else
            {
                do
                {
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    
                    for eachFetchCountry in fetchData {
                        let eachCountry = eachFetchCountry as! [String:Any]
                        let country = eachCountry["name"] as! String
                        
                        
                        self.featchCountry.append(Country(country: country))
                        
                        
                    }
                    
                   
                    self.myTable.reloadData()
                    
                }
                catch
                {
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText == ""
            
        {
            parcedata()
        }else {
            if searchBar.selectedScopeButtonIndex == 0 {
                featchCountry = featchCountry.filter({ (country) -> Bool in
                    return country.country.lowercased().contains(searchText.lowercased())
                })
                
            }
        }
        self.myTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featchCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCell = myTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        
        cell.country.text = self.featchCountry[indexPath.row].country
        cell.country.font = UIFont.systemFont(ofSize: 20.0)
      
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    
        mylable.text = self.featchCountry[indexPath.row].country
     
    }
    
    
    
}


class Country {
    
    var country : String
    init(country : String ) {
        self.country = country
    }
}



