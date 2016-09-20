//
//  ViewController.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 8/23/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = self.contentView.frame.size
    }
    
    // MARK: - UIScrollViewDelegate
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        scrollView.setNeedsDisplay()
//    }
//    
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        scrollView.setNeedsDisplay()
//    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

