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
    var schedule: Schedule?
    var defaultPage: Int = 0

    @IBOutlet private weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager = ApiManager()
        calendarView.scrollDirection = .vertical
        calendarView.delegate = self
        calendarView.dataSource = self
        if origin != nil && destination != nil {
            apiManager?.loadFlight(from: origin!, to: destination!, success: { (schedule: Schedule?) in
                self.onLoadFlight(schedule: schedule)
            }, fail: { (error: NSError) in
                // TODO: Handle error
            })
        }
    }
    
    func onLoadFlight(schedule: Schedule?) {
        self.schedule = schedule
        calendarView.reloadData()
    }
    
    @IBAction func onDoneTapped(_ sender: UIButton) {
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
        let doesFlightExist: Bool = schedule?.timetable?.contains(where: { (timetable: Timetable) -> Bool in
            return weekday == timetable.day
        }) ?? false
        cell.isUserInteractionEnabled = doesFlightExist
        cell.titleLabel.textColor = doesFlightExist ? .black : .lightGray
        if doesFlightExist {
            cell.subtitle = "\(getFlightPrice(forDate: date)) €"
        }
    }
    
    func getFlightPrice(forDate: Date) -> Double {
        return 24
    }
}
