//
//  GridScrollView.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 9/13/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class GridScrollView: UIScrollView, UIScrollViewDelegate {
    
    @IBInspectable var gridColor: UIColor = .white
    
    let gridStep: CGFloat = 4.0
    let zoomConstraint: CGFloat = 100.0
    let alphaThreshold: CGFloat = 0.05
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        panGestureRecognizer.addTarget(self, action: #selector(onPan))
        pinchGestureRecognizer?.addTarget(self, action: #selector(onPinch))
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        backgroundColor?.setFill()
        context.fill(rect)
        
        let phase: CGFloat = 10.0

        //https://www.wolframalpha.com/input/?i=plot(x%2Fpow(2,floor(log(2,x))))x%3D0to16
        
        let scaleFactor1 = zoomScale / pow(zoomConstraint, floor(logC(zoomScale, forBase: zoomConstraint)))
        let scaleFactor2 = (zoomScale * phase) / pow(zoomConstraint, floor(logC((zoomScale * phase), forBase: zoomConstraint)))

        let scaledGridPeriod1 = gridStep * scaleFactor1
        let scaledGridPeriod2 = gridStep * scaleFactor2

        print(zoomScale, scaleFactor1, scaledGridPeriod1)

        let color1 = gridColor.withAlphaComponent(sin(CGFloat.pi * (scaleFactor1 / zoomConstraint)))
        let color2 = gridColor.withAlphaComponent(sin(CGFloat.pi * (scaleFactor2 / zoomConstraint)))
        
        drawGridInContext(context, step: scaledGridPeriod1, color: color1)
        drawGridInContext(context, step: scaledGridPeriod2, color: color2)
    }
    
    func drawGridInContext(_ context: CGContext, step: CGFloat, color: UIColor) {
        
        if color.cgColor.alpha > alphaThreshold {
            
            let offsetX = max(0.0, (step - (bounds.origin.x.truncatingRemainder(dividingBy: step))))
            let offsetY = max(0.0, (step - (bounds.origin.y.truncatingRemainder(dividingBy: step))))
            let offset = CGPoint(x: offsetX, y: offsetY)
            let origin = CGPoint(x: (bounds.origin.x + offset.x), y: (bounds.origin.y + offset.y))

            context.saveGState()
            color.setFill()

            var x = origin.x
            repeat {
                context.fill(CGRect(x: x, y: bounds.origin.y, width: 1, height: bounds.height))
                x += step
            } while (x < (origin.x + bounds.width))

            var y = origin.y
            repeat {
                context.fill(CGRect(x: bounds.origin.x, y: y, width: bounds.width, height: 1))
                y += step
            } while (y < (origin.y + bounds.height))
            
            context.restoreGState()
        }
    }
    
    // MARK: - Gesture Recognizers

    @objc
    func onPinch() {
        setNeedsDisplay()
    }

    @objc
    func onPan() {
        setNeedsDisplay()
    }
    
    // MARK: - Utility
    
    func logC(_ val: CGFloat, forBase base: CGFloat) -> CGFloat {
        return log(val) / log(base)
    }
}



