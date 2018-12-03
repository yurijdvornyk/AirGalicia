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
    var backgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoadingView()
    }
    
    func showLoading() {
        if activityIndicator == nil || backgroundView == nil {
            createLoadingView()
        }
        if (!view.subviews.contains(activityIndicator!)) {
            view.addSubview(activityIndicator!)
        }
        if (!view.subviews.contains(backgroundView!)) {
            view.addSubview(backgroundView!)
        }
        activityIndicator?.startAnimating()
    }

    func hideLoading() {
        if activityIndicator != nil && view.subviews.contains(activityIndicator!) {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
        if backgroundView != nil && view.subviews.contains(backgroundView!) {
            backgroundView?.removeFromSuperview()
        }
    }

    func createLoadingView() {
        let width = Double(view.frame.size.width)
        let height = Double(view.frame.size.height)
            
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        backgroundView!.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        let size = 50.0
        let x = (width - size) / 2.0
        let y = (height - size) / 2.0
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: x, y: y, width: size, height: size))
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.style = UIActivityIndicatorView.Style.gray
        activityIndicator?.hidesWhenStopped = true
    }
    
    func showMessage(title: String?, message: String?, button buttonText: String?, action buttonAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message == nil ? "" : message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText == nil ? "OK" : buttonText, style: UIAlertAction.Style.default, handler: { action in
                buttonAction()
            }))
            self.present(alert, animated: true, completion: nil)
    }
}
