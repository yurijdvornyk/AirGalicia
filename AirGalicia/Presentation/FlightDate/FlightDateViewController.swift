//
//  FlightDateViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/30/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import FSCalendar

protocol FlightDateSelectionDelegate {
    func flightDateSelected(outDate: Date?, backDate: Date?)
}

class FlightDateViewController: BaseViewController {
    
    var selectionDelegate: FlightDateSelectionDelegate?
    var apiManager: ApiManager?
    var origin: String?
    var destination: String?
    var outSchedule: Schedule?
    var backSchedule: Schedule?
    var defaultPage: Int = 0
    var outDate: Date?
    var backDate: Date?

    @IBOutlet private weak var dateControl: UISegmentedControl!
    @IBOutlet private weak var calendarView: FSCalendar!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
        dateControl.selectedSegmentIndex = defaultPage
        calendarView.scrollDirection = .vertical
        calendarView.delegate = self
        calendarView.dataSource = self
        if origin != nil && destination != nil {
            spinner.isHidden = false
            spinner.startAnimating()
            apiManager?.loadFlight(from: origin!, to: destination!, success: { (outSchedule: Schedule?) in
                self.apiManager?.loadFlight(from: self.destination!, to: self.origin!, success: { (backSchedule: Schedule?) in
                    DispatchQueue.main.async() {
                        self.onLoadFlight(outSchedule: outSchedule, backSchedule: backSchedule)
                        self.spinner.stopAnimating()
                    }
                }, fail: { (error: NSError) in
                    DispatchQueue.main.async() {
                        self.spinner.stopAnimating()
                    }
                    // TODO: Handle error
                })
            }, fail: { (error: NSError) in
                DispatchQueue.main.async() {
                    self.spinner.stopAnimating()
                }
                // TODO: Handle error
            })
        }
    }
    
    func onLoadFlight(outSchedule: Schedule?, backSchedule: Schedule?) {
        self.outSchedule = outSchedule
        self.backSchedule = backSchedule
        calendarView.reloadData()
    }
    
    @IBAction func onDateControlToggled(_ sender: UISegmentedControl) {
        calendarView.reloadData()
    }
    
    @IBAction func onDoneTapped(_ sender: UIButton) {
        if selectionDelegate != nil {
            selectionDelegate!.flightDateSelected(outDate: outDate, backDate: backDate)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FlightDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return dateControl.selectedSegmentIndex == 0 || outDate == nil ? Date() : outDate!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: 8, to: Date())!
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let weekday = Calendar.current.component(.weekday, from: date)
        let schedule = dateControl.selectedSegmentIndex == 0 ? outSchedule : backSchedule
        let doesFlightExist: Bool = schedule?.timetable?.contains(where: { (timetable: Timetable) -> Bool in
            return weekday == timetable.day
        }) ?? false
        cell.isUserInteractionEnabled = doesFlightExist
        cell.titleLabel.textColor = doesFlightExist ? .black : .lightGray
        if doesFlightExist {
            cell.subtitle = "\(getFlightPrice(forDate: date)) €"
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if dateControl.selectedSegmentIndex == 0 {
            outDate = date
        } else {
            backDate = date
        }
    }
    
    func getFlightPrice(forDate: Date) -> Double {
        return (dateControl.selectedSegmentIndex == 0 ? outSchedule?.basicPrice : backSchedule?.basicPrice)!
    }
}
