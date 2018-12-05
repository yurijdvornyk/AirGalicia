//
//  DocumentUtils.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 12/3/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit

func exportToPDF(trip: Trip, printFormatter: UIPrintFormatter) -> String {
    let printPageRenderer = PdfPageRenderer()
    printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
    let pdfData = drawPDF(withPageRenderer: printPageRenderer)
    let pdfFilename = "\(NSTemporaryDirectory())/trip\(trip.id).pdf"
    pdfData!.write(toFile: pdfFilename, atomically: true)
    print(pdfFilename)
    return pdfFilename
}

private func drawPDF(withPageRenderer printPageRenderer: UIPrintPageRenderer) -> NSData! {
    let data = NSMutableData()
    UIGraphicsBeginPDFContextToData(data, CGRect(x: 0, y: 0, width: 595.2, height: 841.8), nil)
    UIGraphicsBeginPDFPage()
    printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
    UIGraphicsEndPDFContext()
    return data
}
