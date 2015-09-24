//
//  Renderer.swift
//  EternalTriangle
//
//  Created by hokada on 9/10/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class Layout {
  let sheetMargin: UIEdgeInsets

  public init(sheetMargin: UIEdgeInsets) {
    self.sheetMargin = sheetMargin
  }

  public static let defaultLayout: Layout = Layout(sheetMargin: UIEdgeInsetsZero)
}

public class Renderer : UIView {
  var tune: Tune! = nil
  var layout: Layout! = nil

  public func render(tune : Tune, layout: Layout = Layout.defaultLayout) {
    self.layout = layout
    self.tune = tune
    setNeedsDisplay()
  }

  override public func drawRect(rect: CGRect) {
    renderStaff()
    renderHeader()
    renderVoices()
  }

  private func renderStaff() {
//    let ctx = UIGraphicsGetCurrentContext()
  }

  private func renderHeader() {
  }

  private func renderVoices() {
  }
}
