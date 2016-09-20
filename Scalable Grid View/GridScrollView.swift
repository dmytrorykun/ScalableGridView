//
//  GridScrollView.swift
//  Scalable Grid View
//
//  Created by Dmitry Rykun on 9/13/16.
//  Copyright © 2016 Dmitry Rykun. All rights reserved.
//

import UIKit

class GridScrollView : UIScrollView, UIScrollViewDelegate {
    
    @IBInspectable var gridColor : UIColor = UIColor.whiteColor()
    
    let gridStep : CGFloat = 4.0
    let zoomConstraint : CGFloat = 100.0
    let alphaTreshold : CGFloat = 0.05
    
    convenience init() {
        self.init(frame: CGRectZero)
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
        panGestureRecognizer.addTarget(self, action: "onPan")
        pinchGestureRecognizer?.addTarget(self, action: "onPinch")
    }
    
    override func drawRect(rect: CGRect) {
        
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        backgroundColor?.setFill()
        CGContextFillRect(context, rect)
        
        let phase : CGFloat = 10.0

        //https://www.wolframalpha.com/input/?i=plot(x%2Fpow(2,floor(log(2,x))))x%3D0to16
        
        let scaleFactor1 = zoomScale / pow(zoomConstraint,floor(logC(zoomScale, forBase: zoomConstraint)))
        let scaleFactor2 = (zoomScale * phase) / pow(zoomConstraint, floor(logC((zoomScale * phase), forBase: zoomConstraint)))
        
        let scaledGridPeriod1 = gridStep * scaleFactor1
        let scaledGridPeriod2 = gridStep * scaleFactor2
        
        let color1 = gridColor.colorWithAlphaComponent(sin(CGFloat(M_PI) * (scaleFactor1 / zoomConstraint)))
        let color2 = gridColor.colorWithAlphaComponent(sin(CGFloat(M_PI) * (scaleFactor2 / zoomConstraint)))
        
        drawGridInContext(context, step: scaledGridPeriod1, color: color1)
        drawGridInContext(context, step: scaledGridPeriod2, color: color2)
    }
    
    func drawGridInContext(context: CGContextRef, step: CGFloat, color: UIColor) {
        
        if CGColorGetAlpha(color.CGColor) > alphaTreshold {
            
            let offsetX = max(0.0, (step - (bounds.origin.x % step)))
            let offsetY = max(0.0, (step - (bounds.origin.y % step)))
            let offset = CGPoint(x: offsetX, y: offsetY)
            let origin = CGPoint(x: (bounds.origin.x + offset.x), y: (bounds.origin.y + offset.y))
            
            CGContextSaveGState(context)
            color.setFill()
            
            for var x = origin.x; x < (origin.x + bounds.width); x += step {
                CGContextFillRect(context, CGRectMake(x, bounds.origin.y, 1, bounds.height))
            }
            
            for var y = origin.y; y < (origin.y + bounds.height); y += step {
                CGContextFillRect(context, CGRectMake(bounds.origin.x, y, bounds.width, 1))
            }
            
            CGContextRestoreGState(context)
        }
    }
    
    // MARK: - Gesture Recognizers
    
    func onPinch() {
        setNeedsDisplay()
    }
    
    func onPan() {
        setNeedsDisplay()
    }
    
    // MARK: - Utility
    
    func logC(val: CGFloat, forBase base: CGFloat) -> CGFloat {
        return log(val)/log(base)
    }
}



