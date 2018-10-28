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
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.style = UIActivityIndicatorView.Style.gray
        activityIndicator?.hidesWhenStopped = true
    }
}
