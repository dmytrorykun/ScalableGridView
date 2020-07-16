//
//  ViewController.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 8/23/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var contentView: UIView!

    override func loadView() {
        let scrollView = GridScrollView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1000
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        contentView.backgroundColor = .red
        scrollView.addSubview(contentView)
        self.view = scrollView
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { contentView }
}

