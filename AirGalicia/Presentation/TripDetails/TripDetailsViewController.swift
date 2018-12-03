//
//  TripDetailsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import WebKit

class TripDetailsViewController: BaseViewController, TripUpdateDelegate, BoardingPassGenerationDelegate {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var outTripButton: UIButton!
    @IBOutlet private weak var returnTripButton: UIButton!
    
    var trip: Trip?
    var defaultButtonHeight = 48.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButtonHeight = Double(returnTripButton.frame.height)
        if trip != nil {
            webView.loadHTMLString((trip?.summaryHtml)!, baseURL: nil)
        }
        configureBottomButtons()
    }
    
    @IBAction func onShareTapped(_ sender: UIBarButtonItem) {
        let items = [trip?.summaryHtml]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func onBookingUpdated(booking: Trip?) {
        self.trip = booking
    }
    
    func configureBottomButtons() {
        if trip?.outBoardingPasses != nil {
            outTripButton.setTitle("Out Trip Boarding Pass", for: .normal)
        } else {
            outTripButton.setTitle("Out Trip Check In", for: .normal)
            outTripButton.isEnabled = (trip?.isOutCheckInAvailable(Date()))! || (trip?.hasPassengerWithPriority)!
        }
        if trip?.returnBoardingPasses != nil {
            returnTripButton.setTitle("Return Trip Boarding Pass", for: .normal)
        } else {
            returnTripButton.setTitle("Return Trip Check In", for: .normal)
            returnTripButton.isEnabled = (trip?.isReturnCheckInAvailable(Date()))! || (trip?.hasPassengerWithPriority)!
        }
    }
    
    func onBoardingPassesGenerated(_ boardingPasses: [BoardingPass]) {
        present(Navigator.instance.boardingPass(boardingPasses: boardingPasses), animated: true)
    }
    
    @IBAction func onOutTripButtonTapped(_ sender: UIButton) {
        if trip?.outBoardingPasses != nil {
            present(Navigator.instance.checkIn(trip: trip!, isOutTrip: true, tripDelegate: self as TripUpdateDelegate, boardingPassGenerationDelegate: self as BoardingPassGenerationDelegate), animated: true, completion: nil)
        } else {
            present(Navigator.instance.boardingPass(boardingPasses: (trip?.outBoardingPasses)!), animated: true)
        }
    }
    
    @IBAction func onReturnButtonTapped(_ sender: UIButton) {
        if trip?.returnBoardingPasses != nil {
            present(Navigator.instance.checkIn(trip: trip!, isOutTrip: false, tripDelegate: self as TripUpdateDelegate, boardingPassGenerationDelegate: self as BoardingPassGenerationDelegate), animated: true, completion: nil)
        } else {
            present(Navigator.instance.boardingPass(boardingPasses: (trip?.returnBoardingPasses)!), animated: true)
        }
    }
}
