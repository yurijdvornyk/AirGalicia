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
    @IBOutlet private weak var outDateTextField: UITextField!
    @IBOutlet private weak var outDateStackView: UIStackView!
    @IBOutlet private weak var backDateTextField: UITextField!
    @IBOutlet weak var backDateStackView: UIStackView!
    
    private var apiManager: ApiManager!
    
    private var originAirport: Airport!
    private var destinationAirport: Airport!
    private var flightOutDate: Date!
    private var flightBackDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
        outDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOutDateViewTapped(recognizer:))))
        backDateStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didBackDateViewTapped(recognizer:))))
        clearAirports()
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
        airportsViewController.originAirport = originAirport
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didOutDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 0)
    }
    
    @objc func didBackDateViewTapped(recognizer: UIGestureRecognizer) {
        presentflightDateViewController(defaultPage: 1)
    }
    
    func presentflightDateViewController(defaultPage: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flightDateViewController = storyBoard.instantiateViewController(withIdentifier: "FlightDateViewController") as! FlightDateViewController
        flightDateViewController.selectionDelegate = self
        flightDateViewController.origin = originAirport.code
        flightDateViewController.destination = destinationAirport.code
        flightDateViewController.defaultPage = defaultPage
        present(flightDateViewController, animated: true, completion: nil)
    }
    
    func onAirportSelected(isUserSelectingOrigin: Bool, airport: Airport?) {
        if airport == nil {
            return
        }
        
        if isUserSelectingOrigin {
            originAirport = airport
            destinationAirport = nil
            destinationStackView.isUserInteractionEnabled = true
            destinationTextField.isEnabled = true
            swapDestinationsButton.isEnabled = false
            setDatePickEnabled(false)
        } else {
            destinationAirport = airport
            setDatePickEnabled(true)
        }
        updateAirportTextFields()
    }
    
    func setDatePickEnabled(_ isEnabled: Bool) {
        swapDestinationsButton.isEnabled = isEnabled
        outDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
        backDateStackView.isUserInteractionEnabled = isEnabled
        outDateTextField.isEnabled = isEnabled
    }
    
    func clearAirports() {
        originAirport = nil
        destinationAirport = nil
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
        let tempAirport = originAirport
        originAirport = destinationAirport
        destinationAirport = tempAirport
        updateAirportTextFields()
    }
    
    @IBAction func onTripTypeSwitchValueChanged(_ sender: UISwitch) {
    }
    
    func updateAirportTextFields() {
        originTextField.text = formatAirportForSearchField(airport: originAirport)
        destinationTextField.text = formatAirportForSearchField(airport: destinationAirport)
    }
    
    func flightDateSelected(outDate: Date?, backDate: Date?) {
        flightOutDate = outDate
        flightBackDate = backDate
        updateDates()
    }
    
    private func updateDates() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        outDateTextField.text = flightOutDate == nil ? "" : formatter.string(from: flightOutDate)
        backDateTextField.text = flightBackDate == nil ? "" : formatter.string(from: flightBackDate)
    }
}

//extension SearchViewController: FSCalendarDelegate, FSCalendarDataSource {
//
//    private var isOriginDateSelecting: Bool {
//        get {
//            return tripDatesControl.selectedSegmentIndex == 0
//        }
//    }
//
////    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
////    }
//
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date.init()
//    }
//
//    func maximumDate(for calendar: FSCalendar) -> Date {
//        return Calendar.current.date(byAdding: .month, value: 8, to: Date.init())!
//    }
//
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "24 €"
//    }
//}
