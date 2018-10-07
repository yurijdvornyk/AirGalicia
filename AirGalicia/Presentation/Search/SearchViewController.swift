//
//  FirstViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import FSCalendar

class SearchViewController: BaseViewController, AirportsSelectionDelegate, FlightDateSelectionDelegate {
    
    // TODO: Implementing search bar https://www.youtube.com/watch?v=bWQhhKwPMo4
    // https://www.youtube.com/watch?v=wVeX68Iu43E

    @IBOutlet private weak var originStackView: UIStackView!
    @IBOutlet private weak var originTextField: UITextField!
    @IBOutlet private weak var destinationStackView: UIStackView!
    @IBOutlet private weak var destinationTextField: UITextField!
    @IBOutlet private weak var swapDestinationsButton: UIButton!
    @IBOutlet private weak var tripTypeSwitch: UISwitch!
    @IBOutlet private weak var outDateTextField: UITextField!
    @IBOutlet private weak var outDateStackView: UIStackView!
    @IBOutlet private weak var backDateTextField: UITextField!
    @IBOutlet private weak var backDateStackView: UIStackView!
    @IBOutlet private weak var ticketsCountLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var buyTicketsButton: UIButton!
    
    private var apiManager: ApiManager!
    
    private var booking: Booking!
    
//    private var originAirport: Airport!
//    private var destinationAirport: Airport!
//    private var flightOutDate: Date!
//    private var flightBackDate: Date!
//    private var ticketsCount: Int!
//    private var flightPrice: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
        outDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOutDateViewTapped(recognizer:))))
        backDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didBackDateViewTapped(recognizer:))))
        setUpDefaultScreenData()
    }
    
    @objc func didOriginStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self
        airportsViewController.originAirport = nil
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didDestinationStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self as AirportsSelectionDelegate
        airportsViewController.originAirport = booking.origin
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didOutDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 0)
    }
    
    @objc func didBackDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 1)
    }
    
    func setUpDefaultScreenData() {
        clearAirports()
        booking = Booking()
        booking.passengers?.append(Passenger())
        outDateTextField.text = ""
        backDateTextField.text = ""
        onTicketsCountUpdated()
        updateTotalPrice()
    }
    
    func updateTripDateFields() {
        outDateTextField.isEnabled = booking.origin != nil && booking.destination != nil
        outDateStackView.isUserInteractionEnabled = outDateTextField.isEnabled
        backDateTextField.isEnabled = outDateTextField.isEnabled && tripTypeSwitch.isOn
        backDateStackView.isUserInteractionEnabled = backDateTextField.isEnabled
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if booking.outDate != nil {
            outDateTextField.text = formatter.string(from: booking.outDate!)
            if booking.returnDate != nil && booking.returnDate! > booking.outDate! {
                backDateTextField.text = ""
            }
        }
        if booking.returnDate != nil {
            backDateTextField.text = formatter.string(from: booking.returnDate!)
            if booking.outDate != nil && booking.returnDate! < booking.outDate! {
                outDateTextField.text = ""
            }
        }
    }
    
    func presentflightDateViewController(defaultPage: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flightDateViewController = storyBoard.instantiateViewController(withIdentifier: "FlightDateViewController") as! FlightDateViewController
        flightDateViewController.selectionDelegate = self
        flightDateViewController.origin = booking.origin!.code
        flightDateViewController.destination = booking.destination!.code
        flightDateViewController.defaultPage = defaultPage
        flightDateViewController.outDate = booking.outDate
        flightDateViewController.backDate = booking.returnDate
        present(flightDateViewController, animated: true, completion: nil)
    }
    
    func onAirportSelected(isUserSelectingOrigin: Bool, airport: Airport?) {
        if airport == nil {
            return
        }
        
        if isUserSelectingOrigin {
            booking.origin = airport
            booking.destination = nil
            destinationStackView.isUserInteractionEnabled = true
            destinationTextField.isEnabled = true
            swapDestinationsButton.isEnabled = false
            setDatePickEnabled(false)
        } else {
            booking.destination = airport
            setDatePickEnabled(true)
        }
        updateAirportTextFields()
        updateTripDateFields()
    }
    
    func setDatePickEnabled(_ isEnabled: Bool) {
        swapDestinationsButton.isEnabled = isEnabled
        outDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
        backDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
    }
    
    func clearAirports() {
        booking?.origin = nil
        booking?.destination = nil
        updateAirportTextFields()
        destinationStackView.isUserInteractionEnabled = false
        destinationTextField.isEnabled = false
    }
    
    func formatAirportForSearchField(airport: Airport?) -> String {
        if airport == nil {
            return ""
        } else {
            return "\(airport!.city), \(airport!.country) (\(airport!.name), \(airport!.code))"
        }
    }
    
    @IBAction func onSwapButtonTapped(_ sender: UIButton) {
        let tempAirport = booking.origin
        booking.origin = booking.destination
        booking.destination = tempAirport
        updateAirportTextFields()
    }
    
    @IBAction func onTripTypeSwitchValueChanged(_ sender: UISwitch) {
        updateTripDateFields()
    }
    
    func updateAirportTextFields() {
        originTextField.text = formatAirportForSearchField(airport: booking?.origin)
        destinationTextField.text = formatAirportForSearchField(airport: booking?.destination)
    }
    
    func flightDateSelected(outDate: Date?, backDate: Date?, price: Double) {
        booking.outDate = outDate
        booking.returnDate = backDate
        booking.singlePrice = price
        updateTripDateFields()
        updateTotalPrice()
    }
    
    @IBAction func onMinusTicketTapped(_ sender: UIButton) {
        if (booking.passengers?.count)! > 1 {
            booking.passengers?.removeLast()
            onTicketsCountUpdated()
        }
    }
    
    @IBAction func onPlusTicketTapped(_ sender: UIButton) {
        if (booking.passengers?.count)! < 10 {
            booking.passengers?.append(Passenger())
            onTicketsCountUpdated()
        }
    }
    
    func onTicketsCountUpdated() {
        updateTotalPrice()
        ticketsCountLabel.text = String((booking.passengers?.count)!)
    }
    
    func updateTotalPrice() {
        var result: Int
        if booking.origin == nil || booking.singlePrice == nil {
            result = 0
        } else {
            result = Int(booking.singlePrice!) * (booking.passengers?.count)!
        }
        
        priceLabel.text = "\(String(result)) €"
        buyTicketsButton.isEnabled = result > 0
    }
    
    @IBAction func onBuyTapped(_ sender: UIButton) {
    }
    
    @IBAction func onResetTapped(_ sender: UIButton) {
        setUpDefaultScreenData()
    }
}
