//
//  Animator.swift
//  EternalTriangle
//
//  Created by hokada on 9/23/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public class Animator {
  let target: UIView
  var link: CADisplayLink? = nil
  var previousTime: CFTimeInterval = 0
  var velocity: CGFloat = 0

  public init(target: UIView, tempo: Tempo, distancePerUnit: CGFloat) {
    self.target = target
    let bpmInUnit = tempo.bpm * tempo.inLength.denominator / tempo.inLength.numerator
    let bps = CGFloat(bpmInUnit) / 60
    velocity = distancePerUnit * bps
  }

  public func start() {
    link?.invalidate()
    link = CADisplayLink(target: self, selector: "update:")
    previousTime = CACurrentMediaTime()
    link?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
  }

  public func stop() {
    link?.invalidate()
  }

  @objc private func update(link: CADisplayLink) {
    let dt = link.timestamp - previousTime
    let delta = velocity * CGFloat(dt)

    target.frame = CGRectMake(
      target.frame.origin.x - delta,
      target.frame.origin.y,
      target.frame.size.width,
      target.frame.size.height)

    previousTime = link.timestamp
  }
}