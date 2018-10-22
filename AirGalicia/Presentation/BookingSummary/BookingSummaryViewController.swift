//
//  PayViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import WebKit

class BookingSummaryViewController: BaseViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    var booking: Booking?
    var delegate: BookingUpdateDelegate?
    var content: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(createBookingSummaryHtml(), baseURL: nil)
//        content = []
//        if booking != nil {
//            content?.append("From: \(formatAirportFullString(airport: booking?.origin))")
//            content?.append("To: \(formatAirportFullString(airport: booking?.destination))")
//            content?.append(booking?.returnDate != nil ? "Return Trip" : "One-Way Trip")
//            content?.append(formatFlightDate(booking: booking))
//            content?.append("Passengers: \n\(formatPassengers(passengers: booking?.passengers))")
//        }
    }
    
    func createBookingSummaryHtml() -> String {
        var content = "<html>"
        content += "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
        content += "<body>"
        if booking == nil {
            return content + "No data available.</body></html>"
        }
        content += "<p>From: <b>\(formatAirportFullString(airport: booking?.origin))</b>"
        content += "<p>To: <b>\(formatAirportFullString(airport: booking?.destination))</b>"
        content += "<p>Flight date: <b>\(formatFlightDate(date: booking?.outDate, time: (booking?.outTime)!))</b>"
        if booking?.returnDate != nil && booking?.returnTime != nil {
            content += "<p>Return date: <b>\(formatFlightDate(date: booking?.returnDate, time: (booking?.returnTime)!))</b>"
        }
        content += "<p>Passengers:"
        content += "<ul>"
        for passenger in (booking?.passengers!)! {
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
        content += "</ul>"
        content += "<hr>"
        content += "Total price: <h3>\(booking?.totalPrice ?? 0) €</h3>"
        content += "</body></html>"
        return content
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onConfirmTapped(_ sender: UIButton) {
    }
}
