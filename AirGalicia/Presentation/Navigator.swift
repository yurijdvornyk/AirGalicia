//
//  Navigator.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/10/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class Navigator {
    
    static var instance: Navigator = Navigator()
    
    private init() {}
    
    func tripDetails(trip: Trip, delegate: TripUpdateDelegate) -> TripDetailsViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tripDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "TripDetailsViewController") as! TripDetailsViewController
        tripDetailsViewController.delegate = delegate
        tripDetailsViewController.trip = trip
        return tripDetailsViewController
    }
    
    func checkIn(trip: Trip, delegate: TripUpdateDelegate) -> CheckInViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "CheckIn") as! CheckInViewController
        viewController.delegate = delegate
        viewController.trip = trip
        return viewController
    }
    
    func boardingPassViewController() {
        
    }
}
