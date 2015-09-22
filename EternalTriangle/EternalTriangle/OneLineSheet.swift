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
  public let widthPerUnitNoteLength: CGFloat

  public init(
    staffHeight: CGFloat,
    staveLineWidth: CGFloat,
    widthPerUnitNoteLength: CGFloat) {
      self.staffHeight = staffHeight
      self.staveLineWidth = staveLineWidth
      self.widthPerUnitNoteLength = widthPerUnitNoteLength
  }

  public static let defaultLayout = OneLineSheetLayout(
    staffHeight: 50,
    staveLineWidth: 1,
    widthPerUnitNoteLength: 30)
}

@IBDesignable public class OneLineSheet: UIView {
  @IBInspectable public var foreColor: UIColor! = nil
  @IBInspectable public var highlightedColor: UIColor! = nil
  public var layout: OneLineSheetLayout = OneLineSheetLayout.defaultLayout

  public func loadTune(tune: Tune) {
    if let voice = tune.tuneBody.voices.first {
      var x: CGFloat = 0
      for element in voice.elements {
        switch element {
        case let note as Note:
          let rect = pitchRect(note.pitch, x: x)
          x += noteLengthToWidth(note.length)
          let view = BlackNote()
          view.backgroundColor = UIColor.clearColor()
          view.frame = rect
          addSubview(view)
        case let tuplet as Tuplet: ()
        case let chord as Chord:
          x += noteLengthToWidth(chord.length)
        case let rest as Rest:
          x += noteLengthToWidth(rest.length)
        default: ()
        }
      }
    }
  }

  public override func drawRect(rect: CGRect) {
    drawStaff()
  }

  private var staffTop: CGFloat {
    get {
      let (_ , height) = size
      return (height - layout.staffHeight) / 2
    }
  }

  private func noteLengthToWidth(noteLength: NoteLength) -> CGFloat {
    return layout.widthPerUnitNoteLength * CGFloat(noteLength.numerator) / CGFloat(noteLength.denominator)
  }

  private func pitchRect(pitch: Pitch, x: CGFloat) -> CGRect {
    let height = layout.staffHeight / 5
    let width = height * 1.3
    return CGRect(x: x, y: pitchToY(pitch), width: width, height: height)
  }

  private func drawStaff() {
    let (width, height) = size
    let top = staffTop
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

  private func pitchToY(pitch: Pitch) -> CGFloat {
    let staffInterval = layout.staffHeight / 5
    let noteInterval = staffInterval / 2
    let c0 = staffTop + noteInterval * 9

    return c0 - CGFloat(7 * pitch.offset + pitch.name.rawValue) * noteInterval + layout.staveLineWidth
  }
}
