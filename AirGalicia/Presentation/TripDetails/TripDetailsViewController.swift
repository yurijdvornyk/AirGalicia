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
    
    var delegate: TripUpdateDelegate?
    var trip: Trip?
    var defaultButtonHeight = 48.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultButtonHeight = Double(returnTripButton.frame.height)
        if trip != nil {
            webView.loadHTMLString(createTripHtml(), baseURL: nil)
        }
        configureBottomButtons()
    }
    
    func createTripHtml() -> String {
        let imageUrl = "https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/master/External/Images/booking_title.png"
        var content = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><body><div align=\"center\"><img src=\"\(imageUrl)\" width=\"80%\"/></div>"
        content += "<p>From: <b>\(formatAirportFullString(airport: trip?.origin))</b>"
        content += "<p>To: <b>\(formatAirportFullString(airport: trip?.destination))</b>"
        content += "<p><b>\(trip?.returnDate != nil && trip?.returnTime != nil ? "Return trip" : "One-Way trip")</b>"
        content += "<p>Date: \(formatFlightDate(date: trip?.outDate, time: (trip?.outTime)!))"
        if trip?.returnDate != nil && trip?.returnTime != nil {
            content += " - \(formatFlightDate(date: trip?.returnDate, time: (trip?.returnTime)!))"
        }
        content += "<p>Passengers:"
        content += "<ul>"
        for passenger in (trip?.passengers!)! {
            content += "<li>\(passenger.firstName ?? "") \(passenger.lastName ?? "") [\(passenger.passport ?? "")]"
            if passenger.hasPriority || passenger.hasCheckedBaggage {
                content += " + "
            }
            if passenger.hasPriority {
                content += "Priority boarding"
            }
            if passenger.hasPriority && passenger.hasCheckedBaggage {
                content += ", "
            }
            if passenger.hasCheckedBaggage {
                content += "Checked baggage"
            }
        }
        content += "</ul><hr>"
        content += "<p>You totally paid: \(trip?.totalPrice ?? 0) €"
        content += "<hr>"
        content += "</body></html>"
        return content
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
