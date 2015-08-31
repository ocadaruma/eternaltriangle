//
//  Tune.swift
//  EternalTriangle
//
//  Created by hokada on 8/31/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public struct TuneHeader {
  let tuneTitle: TuneTitle
  let composer: Composer
  let meter: Meter
  let unitNoteLength: UnitNoteLength
  let tempo: Tempo
  let key: Key
}

public struct TuneBody {
  let elements: [Element]
}

public struct Tune {
  let tuneHeader: TuneHeader
  let tuneBody: TuneBody
}