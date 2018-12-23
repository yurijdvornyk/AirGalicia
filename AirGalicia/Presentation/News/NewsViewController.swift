//
//  NewsViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 11/26/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: BaseViewController {

    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://htmlpreview.github.io/?https://raw.githubusercontent.com/yurijdvornyk/AirGalicia/master/External/MockApi/news.html")!))
    }
}
