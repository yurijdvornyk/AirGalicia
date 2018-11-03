//
//  SecondViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class TripsViewController: BaseViewController {
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    var trips: [Booking]?

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        DataManager.shared.loadTrips(success: {
            trips in
            self.trips = trips
            self.tripsTableView.reloadData()
        }, fail: {
            error in
            self.trips = []
            self.tripsTableView.reloadData()
        })
    }
}

extension TripsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips == nil ? 0 : (trips?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TripTableViewCell
        if trips != nil && indexPath.row < trips!.count {
            cell.configureWith(trip: trips![indexPath.row])
        }
        return cell
    }
}
