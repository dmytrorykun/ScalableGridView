//
//  ViewController.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 8/23/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var contentView: UIView!
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { contentView }
}

