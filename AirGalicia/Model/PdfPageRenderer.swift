//
//  PdfPageRenderer.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/3/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

class PdfPageRenderer: UIPrintPageRenderer {
    
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
    }
}
