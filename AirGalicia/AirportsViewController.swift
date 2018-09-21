//
//  AirportsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class AirportsViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let allAirports = ["ABC", "ADF", "GHI", "JKL"]
    var foundAirports = [String]()
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension AirportsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? foundAirports.count : allAirports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = isSearching ? foundAirports[indexPath.row] : allAirports[indexPath.row]
        return cell!
    }
}

extension AirportsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            foundAirports = allAirports
        } else {
            foundAirports = allAirports.filter({$0.lowercased().contains(searchText.lowercased())})
        }
        isSearching = true
        tableView.reloadData()
    }
}
