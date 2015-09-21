//
//  OneLineSheet.swift
//  EternalTriangle
//
//  Created by hokada on 9/21/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class OneLineSheetLayout {
  public let staffHeight: CGFloat
  public let staveLineWidth: CGFloat

  public init(staffHeight: CGFloat, staveLineWidth: CGFloat) {
    self.staffHeight = staffHeight
    self.staveLineWidth = staveLineWidth
  }
}

public class OneLineSheet: UIView {
  public var foreColor: UIColor! = nil
  public var highlightedColor: UIColor! = nil
  public var layout: OneLineSheetLayout! = nil

  public override func drawRect(rect: CGRect) {
    drawStaff()
  }

  private func drawStaff() {
    let (width, height) = size
    let top = (height - layout.staffHeight) / 2
    let ctx = UIGraphicsGetCurrentContext()

    let staffInterval = layout.staffHeight / 5
    CGContextSetLineWidth(ctx, layout.staveLineWidth)
    for i in 0..<5 {
      let offset = staffInterval * CGFloat(i)

      CGContextMoveToPoint(ctx, 0, top + offset)
      CGContextAddLineToPoint(ctx, width, top + offset)
      CGContextStrokePath(ctx)
    }
  }
}