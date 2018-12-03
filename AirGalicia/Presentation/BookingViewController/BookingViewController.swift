//
//  BookingViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/29/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BookingViewController: UIPageViewController, BookingDelegate {
    
    var pages: [BookingPageViewController] = []
    var currentPage: Int = 0
    var booking: Trip?
    var tripUpdateDelegate: TripUpdateDelegate?
    
    override func viewDidLoad() {
        if booking == nil {
            booking = Trip()
        }
        if pages.count == 0 {
            pages = [
                Navigator.instance.passengers(bookingDelegate: self),
                Navigator.instance.bookingSummary(bookingDelegate: self),
                Navigator.instance.payment(bookingDelegate: self)
            ]
        }
        dataSource = self
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if tripUpdateDelegate != nil {
            tripUpdateDelegate!.onBookingUpdated(booking: booking)
        }
    }
    
    func goNext() {
        if currentPage < pages.count - 1 {
            currentPage += 1
            setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
        } else {
            tripUpdateDelegate?.onBookingUpdated(booking: booking)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func goBack() {
        if currentPage > 0 {
            currentPage -= 1
            setViewControllers([pages[currentPage]], direction: .reverse, animated: true, completion: nil)
        } else {
            tripUpdateDelegate?.onBookingUpdated(booking: booking)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension BookingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return currentPage == 0 ? nil : pages[currentPage - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return currentPage == pages.count - 1 ? nil : pages[currentPage + 1]
    }
}

protocol BookingDelegate {
    var booking: Trip? { get set }
    func goNext()
    func goBack()
}
