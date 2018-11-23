//
//  BoardingPassesViewController.swift
//  AirGalicia
//
//  Created by Yurii Dvornyk on 9/20/18.
//  Copyright © 2018 Yurii Dvornyk. All rights reserved.
//

import WebKit

class BoardingPassesViewController: BaseViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var boardingPasses: [BoardingPass]?

    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = boardingPasses!.count
        for i in 0..<boardingPasses!.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(i)
            frame.size = scrollView.frame.size
            
            let webView = WKWebView(frame: frame)
            webView.loadHTMLString(boardingPasses![i].makeHtmlString(), baseURL: nil)
            scrollView.addSubview(webView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(boardingPasses!.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension BoardingPassesViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

protocol BoardingPassGenerationDelegate {
    func onBoardingPassesGenerated(_ boardingPasses: [BoardingPass])
}
