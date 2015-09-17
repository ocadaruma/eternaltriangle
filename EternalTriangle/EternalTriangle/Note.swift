//
//  Note.swift
//  EternalTriangle
//
//  Created by hokada on 9/16/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

@IBDesignable public class DefaultNote: SheetElement {
  @IBInspectable public var ballHeight: CGFloat = 0
  @IBInspectable public var lineWidth: CGFloat = 0
  @IBInspectable public var invert: Bool = false

  public override func drawRect(rect: CGRect) {
    let (width, height) = size
    let bHeight = ballHeight
    let lWidth = lineWidth

    let w = width
    let h = bHeight
    let y = height - bHeight

    let ctx = UIGraphicsGetCurrentContext()

    if invert {
      CGContextTranslateCTM(ctx, w / 2, height / 2)
      CGContextRotateCTM(ctx, CGFloat(M_PI))
      CGContextTranslateCTM(ctx, -w / 2, -height / 2)
    }

    //// Oval drawing
    let oval = UIBezierPath()
    oval.moveToPoint(CGPointMake(w * 0.19588999999999998, y + h * 0.20055555555555557))
    oval.addCurveToPoint(CGPointMake(w * 0.09838, y + h * 0.8963777777777778), controlPoint1: CGPointMake(w * -0.02521, y + h * 0.4212), controlPoint2: CGPointMake(w * -0.06887, y + h * 0.7327333333333333))
    oval.addCurveToPoint(CGPointMake(w * 0.80152, y + h * 0.7931777777777778), controlPoint1: CGPointMake(w * 0.26562, y + h * 1.0600222222222222), controlPoint2: CGPointMake(w * 0.58043, y + h * 1.0138222222222222))
    oval.addCurveToPoint(CGPointMake(w * 0.8990300000000001, y + h * 0.09735555555555556), controlPoint1: CGPointMake(w * 1.02262, y + h * 0.5725333333333333), controlPoint2: CGPointMake(w * 1.06627, y + h * 0.2610111111111111))
    oval.addCurveToPoint(CGPointMake(w * 0.19588999999999998, y + h * 0.20055555555555557), controlPoint1: CGPointMake(w * 0.73179, y + h * -0.0662888888888889), controlPoint2: CGPointMake(w * 0.41698, y + h * -0.02008888888888889))


    //Oval color fill
    tintColor.setFill()
    oval.fill()

    CGContextFillRect(ctx, CGRectMake(w - lWidth, 0, lWidth, y + bHeight / 3))
  }
}

@IBDesignable public class HalfNote: SheetElement {
  @IBInspectable public var ballHeight: CGFloat = 0
  @IBInspectable public var lineWidth: CGFloat = 0
  @IBInspectable public var invert: Bool = false

  public override func drawRect(rect: CGRect) {
    let (width, height) = size
    let bHeight = ballHeight
    let lWidth = lineWidth

    let w = width
    let h = bHeight
    let y = height - bHeight

    let ctx = UIGraphicsGetCurrentContext()

    if invert {
      CGContextTranslateCTM(ctx, w / 2, height / 2)
      CGContextRotateCTM(ctx, CGFloat(M_PI))
      CGContextTranslateCTM(ctx, -w / 2, -height / 2)
    }

    //// Oval drawing
    let oval = UIBezierPath()
    oval.moveToPoint(CGPointMake(w * 0.19588999999999998, y + h * 0.20055555555555557))
    oval.addCurveToPoint(CGPointMake(w * 0.09838, y + h * 0.8963777777777778), controlPoint1: CGPointMake(w * -0.02521, y + h * 0.4212), controlPoint2: CGPointMake(w * -0.06887, y + h * 0.7327333333333333))
    oval.addCurveToPoint(CGPointMake(w * 0.80152, y + h * 0.7931777777777778), controlPoint1: CGPointMake(w * 0.26562, y + h * 1.0600222222222222), controlPoint2: CGPointMake(w * 0.58043, y + h * 1.0138222222222222))
    oval.addCurveToPoint(CGPointMake(w * 0.8990300000000001, y + h * 0.09735555555555556), controlPoint1: CGPointMake(w * 1.02262, y + h * 0.5725333333333333), controlPoint2: CGPointMake(w * 1.06627, y + h * 0.2610111111111111))
    oval.addCurveToPoint(CGPointMake(w * 0.19588999999999998, y + h * 0.20055555555555557), controlPoint1: CGPointMake(w * 0.73179, y + h * -0.0662888888888889), controlPoint2: CGPointMake(w * 0.41698, y + h * -0.02008888888888889))


    //Oval color fill
    tintColor.setFill()
    oval.fill()

    //// Oval2 drawing
    let oval2 = UIBezierPath()
    oval2.moveToPoint(CGPointMake(w * 0.19219999999999998, y + h * 0.5243444444444445))
    oval2.addCurveToPoint(CGPointMake(w * 0.25123, y + h * 0.8863), controlPoint1: CGPointMake(w * 0.05276, y + h * 0.7376888888888888), controlPoint2: CGPointMake(w * 0.07919, y + h * 0.8997444444444445))
    oval2.addCurveToPoint(CGPointMake(w * 0.81521, y + h * 0.47565555555555555), controlPoint1: CGPointMake(w * 0.42327, y + h * 0.8728444444444444), controlPoint2: CGPointMake(w * 0.67577, y + h * 0.689))
    oval2.addCurveToPoint(CGPointMake(w * 0.75618, y + h * 0.11371111111111111), controlPoint1: CGPointMake(w * 0.95465, y + h * 0.2623111111111111), controlPoint2: CGPointMake(w * 0.92822, y + h * 0.10025555555555556))
    oval2.addCurveToPoint(CGPointMake(w * 0.19219999999999998, y + h * 0.5243444444444445), controlPoint1: CGPointMake(w * 0.58414, y + h * 0.12715555555555558), controlPoint2: CGPointMake(w * 0.33164, y + h * 0.311))


    //Oval2 color fill
    backgroundColor?.setFill()
    oval2.fill()
    
    tintColor.setFill()
    CGContextFillRect(ctx, CGRectMake(w - lWidth, 0, lWidth, y + bHeight / 3))
  }
}

@IBDesignable public class WholeNote: SheetElement {
  public override func drawRect(rect: CGRect) {
    let (w, h) = size

    //// Oval drawing
    let oval = UIBezierPath(rect: bounds)

    //Oval color fill
    tintColor.setFill()
    oval.fill()

    //// Oval2 drawing
    let oval2 = UIBezierPath()
    oval2.moveToPoint(CGPointMake(w * 0.71433, h * 0.32087))
    oval2.addCurveToPoint(CGPointMake(w * 0.25504, h * 0.11904), controlPoint1: CGPointMake(w * 0.5733, h * 0.10984), controlPoint2: CGPointMake(w * 0.36767, h * 0.0194857))
    oval2.addCurveToPoint(CGPointMake(w * 0.30644, h * 0.681414), controlPoint1: CGPointMake(w * 0.14241, h * 0.2186), controlPoint2: CGPointMake(w * 0.16542, h * 0.47))
    oval2.addCurveToPoint(CGPointMake(w * 0.76573, h * 0.883257), controlPoint1: CGPointMake(w * 0.44746, h * 0.892457), controlPoint2: CGPointMake(w * 0.65309, h * 0.98281))
    oval2.addCurveToPoint(CGPointMake(w * 0.71433, h * 0.32087), controlPoint1: CGPointMake(w * 0.87836, h * 0.7836857), controlPoint2: CGPointMake(w * 0.85535, h * 0.5319))


    //Oval2 color fill
    backgroundColor?.setFill()
    oval2.fill()
  }
}
