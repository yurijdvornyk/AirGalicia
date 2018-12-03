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
    
    func bookingFlow(tripUpdateDelegate: TripUpdateDelegate, booking: Trip?) -> BookingViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BookingViewController") as! BookingViewController
        viewController.tripUpdateDelegate = tripUpdateDelegate
        viewController.booking = booking
        return viewController
    }
    
    func bookingSummary(bookingDelegate: BookingDelegate) -> BookingSummaryViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BookingSummaryViewController") as! BookingSummaryViewController
        viewController.bookingDelegate = bookingDelegate
        return viewController
    }
    
    func passengers(bookingDelegate: BookingDelegate) -> PassengersViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PassengersViewController") as! PassengersViewController
        viewController.bookingDelegate = bookingDelegate
        return viewController
    }
    
    func payment(bookingDelegate: BookingDelegate) -> PayViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "PayViewController") as! PayViewController
        viewController.bookingDelegate = bookingDelegate
        return viewController
    }
    
    func tripDetails(trip: Trip, delegate: TripUpdateDelegate) -> TripDetailsViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tripDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "TripDetailsViewController") as! TripDetailsViewController
        tripDetailsViewController.delegate = delegate
        tripDetailsViewController.trip = trip
        return tripDetailsViewController
    }
    
    func checkIn(trip: Trip, isOutTrip: Bool, tripDelegate: TripUpdateDelegate, boardingPassGenerationDelegate: BoardingPassGenerationDelegate) -> CheckInViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "CheckIn") as! CheckInViewController
        viewController.tripDelegate = tripDelegate
        viewController.boardingPassGenerationDelegate = boardingPassGenerationDelegate
        viewController.trip = trip
        viewController.isOutTrip = isOutTrip
        
        return viewController
    }
    
    func boardingPass(boardingPasses: [BoardingPass]) -> BoardingPassesViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "BoardingPassesViewController") as! BoardingPassesViewController
        viewController.boardingPasses = boardingPasses
        return viewController
    }
}
