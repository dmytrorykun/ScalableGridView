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
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.setNeedsDisplay()
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setNeedsDisplay()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        contentView
    }
}

