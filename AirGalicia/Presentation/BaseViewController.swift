//
//  BaseViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoadingView()
    }
    
    func showLoading() {
        if activityIndicator == nil {
            createLoadingView()
        }
        if (!view.subviews.contains(activityIndicator!)) {
            view.addSubview(activityIndicator!)
        }
        activityIndicator?.startAnimating()
        print("Show loading")
    }

    func hideLoading() {
        if activityIndicator != nil && view.subviews.contains(activityIndicator!) {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            print("Hide loading")
        }
    }

    func createLoadingView() {
        let size = 50.0
        let x = (Double(view.frame.size.width) - size) / 2.0
        let y = (Double(view.frame.size.height) - size) / 2.0
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: x, y: y, width: size, height: size))
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.style = UIActivityIndicatorView.Style.gray
        activityIndicator?.hidesWhenStopped = true
    }
}
