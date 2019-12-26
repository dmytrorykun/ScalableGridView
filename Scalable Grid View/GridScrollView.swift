//
//  GridScrollView.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 9/13/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class GridScrollView: UIScrollView {
    
    @IBInspectable var gridColor: UIColor = .white
    
    private let gridStep: CGFloat = 4
    private let period: CGFloat = 10
    private let minOpacity: CGFloat = 0.05

    override var bounds: CGRect {
        didSet { setNeedsDisplay() }
    }

    private func drawGrid(in context: CGContext, zoomScaleDelta: CGFloat) {

        let gridScale = zoomScaleDelta * zoomScale / pow(period, floor(log(zoomScale) / log(period)))

        let alpha = sin(.pi * (gridScale / pow(period, 2)))

        guard alpha > minOpacity else { return }

        gridColor.withAlphaComponent(alpha).setFill()

        let k = gridStep * gridScale

        let bx = (floor(bounds.minX / k) + 1) * k
        let by = (floor(bounds.minY / k) + 1) * k

        (0...Int(bounds.width / k))
            .map { CGRect(x: CGFloat($0) * k + bx, y: bounds.minY, width: 1, height: bounds.height) }
            .forEach(context.fill)

        (0...Int(bounds.height / k))
            .map { CGRect(x: bounds.minX, y: CGFloat($0) * k + by, width: bounds.width, height: 1) }
            .forEach(context.fill)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        backgroundColor?.setFill()
        context.fill(rect)
        drawGrid(in: context, zoomScaleDelta: 1)
        drawGrid(in: context, zoomScaleDelta: period)
    }
}
