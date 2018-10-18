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
    func onOutDateSelected(date: Date?, price: Double)
    func onBackDateSelected(date: Date?, price: Double)
}

enum FlightDateType {
    case Out, Back
}

class FlightDateViewController: BaseViewController {
    
    var selectionDelegate: FlightDateSelectionDelegate?
    var apiManager: ApiManager?
    var origin: String?
    var destination: String?
    var outSchedule: Schedule?
    var backSchedule: Schedule?
    var dateType: FlightDateType?
    var outDate: Date?
    var backDate: Date?

    @IBOutlet private weak var calendarView: FSCalendar!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
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
            if dateType == .Out {
                selectionDelegate!.onOutDateSelected(date: outDate, price: getFlightPrice(forDate: outDate))
            } else {
                selectionDelegate!.onBackDateSelected(date: backDate, price: getFlightPrice(forDate: backDate))
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FlightDateViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .month, value: 8, to: Date())!
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let weekday = Calendar.current.component(.weekday, from: date)
        let schedule = dateType == .Out ? outSchedule : backSchedule
        let doesFlightExist: Bool = schedule?.timetable?.contains(where: { (timetable: Timetable) -> Bool in
            return weekday == timetable.day
        }) ?? false
        cell.isUserInteractionEnabled = doesFlightExist
        cell.isSelected = dateType == .Out ? date == outDate : date == backDate
        cell.titleLabel.textColor = doesFlightExist ? .black : .lightGray
        if doesFlightExist {
            cell.subtitle = "\(getFlightPrice(forDate: date)) €"
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if dateType == .Out {
            outDate = date
        } else {
            backDate = date
        }
    }
    
    func getFlightPrice(forDate date: Date?) -> Double {
        if date == nil {
            return 0
        } else {
            return (dateType == .Out ? outSchedule?.basicPrice : backSchedule?.basicPrice)!
        }
    }
}
