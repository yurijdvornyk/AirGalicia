//
//  SearchAirportsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class AirportsViewController: BaseViewController {
    
    var results = ["ABC", "DEF", "GHI"]

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DONE!!!")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension AirportsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = results[indexPath.row]
        return cell!
    }
}
