//
//  BankCardView.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/13/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class BankCardView: UIView {
    
    private let BANK_CARD_VIEW_NIB_NAME = "BankCardView"
    
    @IBOutlet private var contentView: BankCardView!
    @IBOutlet private weak var cardNumberField: UITextField!
    @IBOutlet private weak var expireDateTextField: UITextField!
    @IBOutlet private weak var cvvTextField: UITextField!
    private var initCalled = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(BANK_CARD_VIEW_NIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
}
extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
