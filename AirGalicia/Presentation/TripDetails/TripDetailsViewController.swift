//
//  TripDetailsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 10/28/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import WebKit

class TripDetailsViewController: BaseViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    var delegate: TripUpdateDelegate?
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
        if trip != nil {
            webView.loadHTMLString(createTripHtml(), baseURL: nil)
        }
    }
    
    func createTripHtml() -> String {
        let imageUrl = "https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/blob/master/External/Images/booking_title.png"
        var result = "<html><head></head><body><img src=\"\(imageUrl)\" align=\"center\" width=\"50%\"/>"
        result += "</body></html>"
        return result
    }
    
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
//    func updateBookingView() {
//        webView.loadHTMLString(createBookingSummaryHtml(), baseURL: nil)
//    }
//
//    func createBookingSummaryHtml() -> String {
//        var content = "<html>"
//        content += "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
//        content += "<body>"
//        if booking == nil {
//            return content + "No data available.</body></html>"
//        }
//        content += "<p>From: <b>\(formatAirportFullString(airport: booking?.origin))</b>"
//        content += "<p>To: <b>\(formatAirportFullString(airport: booking?.destination))</b>"
//        content += "<p>Flight date: <b>\(formatFlightDate(date: booking?.outDate, time: (booking?.outTime)!))</b>"
//        if booking?.returnDate != nil && booking?.returnTime != nil {
//            content += "<p>Return date: <b>\(formatFlightDate(date: booking?.returnDate, time: (booking?.returnTime)!))</b>"
//        }
//        content += "<p>Passengers:"
//        content += "<ul>"
//        for passenger in (booking?.passengers!)! {
//            content += "<li>\(passenger.firstName ?? "") \(passenger.lastName ?? "") [\(passenger.passport ?? "")]"
//            if passenger.hasPriority || passenger.hasCheckedBaggage {
//                content += " + "
//            }
//            if passenger.hasPriority {
//                content += "Priority boarding"
//            }
//            if passenger.hasPriority && passenger.hasCheckedBaggage {
//                content += ", "
//            }
//            if passenger.hasCheckedBaggage {
//                content += "Checked baggage"
//            }
//        }
//        content += "</ul>"
//        content += "<hr>"
//        content += "Total price: <h3>\(booking?.totalPrice ?? 0) €</h3>"
//        content += "</body></html>"
//        return content
//    }
}
