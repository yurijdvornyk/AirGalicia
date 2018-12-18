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
    @IBOutlet weak var expireDateView: UIStackView!
    @IBOutlet private weak var expireDateTextField: UITextField!
    @IBOutlet private weak var cvvTextField: UITextField!
    
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
//        expireDateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onExpireViewTapped(recognizer:))))
        let datePicker = CardExpireDatePickerView()
        expireDateTextField.inputView = datePicker
    }
    
    @objc func didChangeValue(textField: UITextField) {
        let range = textField.selectedTextRange
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
        textField.selectedTextRange = range
        
//        let location = textField.offset(from: textField.beginningOfDocument, to: range.start)
//        let length = textField.offset(from: range.start, to: range.end)
//        let rrange = NSRange(location: location, length: length)
//
//        let previousText = textField.text!
//        if (textField.text?.count)! > previousText.count {
//            let beginning = textField.beginningOfDocument
//            let start = textField.position(from: beginning, offset: rrange.location)
//            let end = textField.position(from: start!, offset: range.length)
//            let textRange = textField.textRange(from: start!, to: end!)
//            let cursorOffset = textField.offset(from: beginning, to: start!) + difference
//
//            //        // just used same text, use whatever you want :)3
//            //        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
//
//            let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset: cursorOffset)
//            if newCursorPosition != nil {
//                let newSelectedRange = textField.textRange(from: newCursorPosition!, to: newCursorPosition!)
//                textField.selectedTextRange = newSelectedRange
//            }
//        }
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
    
    @objc func onExpireViewTapped(recognizer: UIGestureRecognizer) {
        print("Expire date tapped")
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
