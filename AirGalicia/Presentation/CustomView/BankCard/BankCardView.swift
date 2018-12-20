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
    
    private var expireDateDelegate: CardExpireDateDelegate?
    
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
        let datePicker = CardExpireDatePickerView()
        expireDateDelegate = datePicker
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onExpireDateSelected))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onExpireDateCancelled))
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        expireDateTextField.inputView = datePicker
        expireDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func didChangeValue(textField: UITextField) {
        let textRange = textField.selectedTextRange
        let previousText = textField.text!
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
        
        let location = textField.offset(from: textField.beginningOfDocument, to: textRange!.start)
        let length = textField.offset(from: textRange!.start, to: textRange!.end)
        let range = NSRange(location: location, length: length)
        
        if (textField.text?.count)! > previousText.count {
            let beginning = textField.beginningOfDocument
            let start = textField.position(from: beginning, offset: range.location)
            let cursorOffset = textField.offset(from: beginning, to: start!) + abs(previousText.count - textField.text!.count)

            let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset: cursorOffset)
            if newCursorPosition != nil {
                let newSelectedRange = textField.textRange(from: newCursorPosition!, to: newCursorPosition!)
                textField.selectedTextRange = newSelectedRange
            }
        } else {
            textField.selectedTextRange = textRange
        }
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
    
    
    @objc func onExpireDateSelected() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        if expireDateDelegate != nil {
            let (month, year) = (expireDateDelegate?.getExpireDate()) ?? (0, 0)
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            if month > 0 && year > 0 {
                expireDateTextField.text = dateFormatter.string(from: Calendar.current.date(from: dateComponents)!)
            }
        }
        contentView.endEditing(true)
    }
    
    @objc func onExpireDateCancelled() {
        print("Cancel tapped")
        contentView.endEditing(true)
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

protocol CardExpireDateDelegate {
    func getExpireDate() -> (Int, Int)
}
