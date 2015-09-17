//
//  UIView.swift
//  EternalTriangle
//
//  Created by hokada on 9/15/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

extension UIView {
  var size: (CGFloat, CGFloat) {
    get {
      return (bounds.size.width, bounds.size.height)
    }
  }
}