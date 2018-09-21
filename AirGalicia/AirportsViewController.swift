//
//  AirportsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/21/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

protocol AirportsSelectedProtocol {
    func onSelected(routePoint: RoutePoint?, airport: String?)
}

class AirportsViewController: BaseViewController {
    
    var selectionDelegate: AirportsSelectedProtocol?
    var routePoint: RoutePoint?
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let allAirports = ["ABC", "ADF", "GHI", "JKL"]
    private var foundAirports = [String]()
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        foundAirports = allAirports
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = isSearching ? foundAirports[indexPath.row] : allAirports[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate?.onSelected(routePoint: routePoint, airport: foundAirports[indexPath.row])
        dismiss(animated: true, completion: nil)
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
