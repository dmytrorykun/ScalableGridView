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
    
    var gridColor: UIColor = .white {
        didSet {
            shapeLayer1.strokeColor = gridColor.cgColor
            shapeLayer2.strokeColor = gridColor.cgColor
        }
    }

    var lineWidth: CGFloat = 1 {
        didSet {
            shapeLayer1.lineWidth = lineWidth
            shapeLayer2.lineWidth = lineWidth
        }
    }

    var gridStep: CGFloat = 4
    var period: CGFloat = 10
    var minOpacity: CGFloat = 0.05

    override var bounds: CGRect {
        didSet { updateGrid() }
    }

    private lazy var shapeLayer1 = makeShapeLayer()
    private lazy var shapeLayer2 = makeShapeLayer()

    private func makeShapeLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = gridColor.cgColor
        shapeLayer.lineWidth = lineWidth
        return shapeLayer
    }

    private func updatedGrid(zoomScaleDelta: CGFloat) -> (CGPath, CGColor) {
        let gridScale = zoomScaleDelta * zoomScale / pow(period, floor(log(zoomScale) / log(period)))
        let alpha = sin(.pi * (gridScale / pow(period, 2)))
        return (gridPath(gridScale * gridStep, bounds).cgPath,
                gridColor.withAlphaComponent(alpha).cgColor)
    }

    private func updateGrid() {
        (shapeLayer1.path, shapeLayer1.strokeColor) = updatedGrid(zoomScaleDelta: 1)
        (shapeLayer2.path, shapeLayer2.strokeColor) = updatedGrid(zoomScaleDelta: period)
        shapeLayer1.removeAllAnimations()
        shapeLayer2.removeAllAnimations()
    }

    private func setupLayers() {
        layer.addSublayer(shapeLayer1)
        layer.addSublayer(shapeLayer2)
        updateGrid()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    override func didMoveToWindow() {
        updateGrid()
    }
}
