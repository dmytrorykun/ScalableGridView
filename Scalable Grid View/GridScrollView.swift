//
//  GridScrollView.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 9/13/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

extension UIBezierPath {

    convenience init(lineFrom p0: CGPoint, to p1: CGPoint) {
        self.init()
        move(to: p0)
        addLine(to: p1)
    }

    convenience init(union paths: [UIBezierPath]) {
        self.init()
        paths.forEach(append)
    }
}

extension Array where Element == UIBezierPath {
    func joined() -> UIBezierPath {
        UIBezierPath(union: self)
    }
}

func gridPath(_ step: CGFloat, _ bounds: CGRect) -> UIBezierPath {

    let minX = (floor(bounds.minX / step) + 1) * step
    let minY = (floor(bounds.minY / step) + 1) * step

    let verticals = stride(from: minX, to: bounds.maxX, by: step)
        .map { (CGPoint(x: $0, y: bounds.minY),
                CGPoint(x: $0, y: bounds.maxY)) }

    let horizontals = stride(from: minY, to: bounds.maxY, by: step)
        .map { (CGPoint(x: bounds.minX, y: $0),
                CGPoint(x: bounds.maxX, y: $0)) }

    return (verticals + horizontals)
            .map(UIBezierPath.init(lineFrom:to:))
            .joined()
}

class GridScrollView: UIScrollView {
    
    var gridColor: UIColor = .white
    var lineWidth: CGFloat = 1
    var gridStep: CGFloat = 4
    var period: CGFloat = 10
    var minOpacity: CGFloat = 0.05

    override var bounds: CGRect {
        didSet { setNeedsDisplay() }
    }

    private func drawGrid(in context: CGContext, zoomScaleDelta: CGFloat) {
        let gridScale = zoomScaleDelta * zoomScale / pow(period, floor(log(zoomScale) / log(period)))
        let alpha = sin(.pi * (gridScale / pow(period, 2)))
        guard alpha > minOpacity else { return }
        gridColor.withAlphaComponent(alpha).setStroke()
        let path = gridPath(gridScale * gridStep, bounds)
        path.lineWidth = lineWidth
        context.addPath(path.cgPath)
        context.strokePath()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        backgroundColor?.setFill()
        context.fill(rect)
        drawGrid(in: context, zoomScaleDelta: 1)
        drawGrid(in: context, zoomScaleDelta: period)
    }
}
