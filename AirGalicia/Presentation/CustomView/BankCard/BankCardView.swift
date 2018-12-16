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
        cardNumberField.addTarget(self, action: #selector(didChangeValue(textField:)), for: .editingChanged)
    }
    
    @objc func didChangeValue(textField: UITextField) {
        let range = textField.selectedTextRange
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
        textField.selectedTextRange = range
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        var modifiedCreditCardString = ""
        if trimmedString.count > 0 {
            for i in 0...trimmedString.count - 1 {
                let index = trimmedString.index(trimmedString.startIndex, offsetBy: i)
                modifiedCreditCardString.append(trimmedString[index])
                if (i + 1) % 4 == 0 && i + 1 != trimmedString.count {
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
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

extension BankCardView: UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.count + string.count - range.length
        return textField == cardNumberField ? newLength <= 19 : true
    }
}
