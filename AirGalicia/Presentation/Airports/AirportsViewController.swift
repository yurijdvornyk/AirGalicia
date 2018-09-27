//
//  AirportsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

protocol AirportsSelectedProtocol {
    func onSelected(isUserSelectingOrigin: Bool, airport: Airport?)
}

class AirportsViewController: BaseViewController {
    
    var selectionDelegate: AirportsSelectedProtocol?
    var originAirport: Airport?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private var allAirports = [Airport]()
    private var foundAirports = [Airport]()
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        ApiManager.init().loadAirports(success: { (airports: [Airport]) in
            self.allAirports = airports
            self.foundAirports = airports
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }) { (error: NSError) in
            // TODO: Handle error
        }
    }
    
    @IBAction func onDismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AirportsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? foundAirports.count : allAirports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AirportSearchCell
        cell.configureWith(airport: foundAirports[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.onSelected(isUserSelectingOrigin: originAirport == nil, airport: foundAirports[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension AirportsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            foundAirports = allAirports
        } else {
            foundAirports = allAirports.filter({
                let query = searchText.lowercased()
                return $0.name.lowercased().contains(query) ||
                $0.city.lowercased().contains(query) ||
                $0.country.lowercased().contains(query) ||
                $0.code.lowercased().contains(query)
            })
        }
        isSearching = true
        tableView.reloadData()
    }
}
