//
//  FirstViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, AirportsSelectedProtocol {
    
    // TODO: Implementing search bar https://www.youtube.com/watch?v=bWQhhKwPMo4
    // https://www.youtube.com/watch?v=wVeX68Iu43E

    @IBOutlet private weak var originStackView: UIStackView!
    @IBOutlet private weak var originTextField: UITextField!
    @IBOutlet private weak var destinationStackView: UIStackView!
    @IBOutlet weak var destinationTextField: UITextField!
    
    private var originAirport: String!
    private var destinationAirport: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
        clearSelection()
    }
    
    @objc func didOriginStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self
        airportsViewController.routePoint = .origin
        present(airportsViewController, animated: true, completion: nil)
    }
    
    @objc func didDestinationStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController") as! AirportsViewController
        airportsViewController.selectionDelegate = self
        airportsViewController.routePoint = .destination
        present(airportsViewController, animated: true, completion: nil)
    }
    
    func onSelected(routePoint: RoutePoint?, airport: String?) {
        if airport == nil {
            return
        }
        
        switch routePoint {
        case .origin?:
            originAirport = airport
            originTextField.text = airport
            destinationStackView.isUserInteractionEnabled = true
        case .destination?:
            destinationAirport = airport
            destinationTextField.text = airport
        case .none:
            break
        }
    }
    
    func clearSelection() {
        originTextField.text = ""
        destinationTextField.text = ""
        destinationStackView.isUserInteractionEnabled = false
    }
}

enum RoutePoint {
    case origin
    case destination
}
