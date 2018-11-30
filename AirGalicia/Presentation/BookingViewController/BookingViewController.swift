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
        addUIButton()
        addSecondUIButton()
    }
    
    func goNext() {
    }
    
    func goBack() {
    }
    
    func addNavigationBar() {
//        let navigationBar = UINavigationBar()
//        navigationBar.backItem = UINavigationItem(title: "Back")
//        navigationBar.items = [
//            UINavigationItem(title: "Back"),
//            UINavigationItem(title: "Continue")
//        ]
//        navigationBar.title
    }
    
    func addUIButton(){
        //next button
        let myButton = UIButton()
        myButton.setTitle("Next", for: UIControl.State.normal)
        myButton.setTitleColor(UIColor.red, for: .normal)
        myButton.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height/2 - 50, width: 50, height: 50)
        //myButton.addTarget(self, action: #selector(pagesViewController.pressed(sender:)), for: .touchUpInside)
        self.view.addSubview(myButton)
        self.view.bringSubviewToFront(myButton)
    }
    
    func addSecondUIButton(){
        //previous button
        let myButton = UIButton()
        myButton.setTitle("Previous", for: UIControl.State.normal)
        myButton.setTitleColor(UIColor.red, for: .normal)
        myButton.frame = CGRect(x: 20, y: self.view.frame.size.height/2 - 50, width: 100, height: 50)
        //myButton.addTarget(self, action: #selector(pagesViewController.Secondpressed(sender:)), for: .touchUpInside)
        self.view.addSubview(myButton)
        self.view.bringSubviewToFront(myButton)
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
