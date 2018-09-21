//
//  FirstViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    // TODO: Implementing search bar https://www.youtube.com/watch?v=bWQhhKwPMo4
    // https://www.youtube.com/watch?v=wVeX68Iu43E

    @IBOutlet private weak var originStackView: UIStackView!
    @IBOutlet private weak var originTextField: UITextField!
    @IBOutlet private weak var destinationStackView: UIStackView!
    @IBOutlet weak var destinationTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        originStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didOriginStackViewTapped(recognizer:))))
        destinationStackView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didDestinationStackViewTapped(recognizer:))))
    }
    
    @objc func didOriginStackViewTapped(recognizer: UIGestureRecognizer) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let airportsViewController = storyBoard.instantiateViewController(withIdentifier: "AirportsViewController")
        present(airportsViewController, animated: true, completion: nil)
        //self.navigationController?.pushViewController(airportsViewController, animated: true)
    }
    
    @objc func didDestinationStackViewTapped(recognizer: UIGestureRecognizer) {
        //present(SearchAirportsViewController(), animated: true, completion: nil)
    }
}
