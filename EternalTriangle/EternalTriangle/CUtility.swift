//
//  CUtility.swift
//  EternalTriangle
//
//  Created by hokada on 9/10/15.
//  Copyright (c) 2015 Haruki Okada. All rights reserved.
//

import Foundation

public func CheckError(err: OSStatus) {
  if err == noErr {
    return
  }

  println("error occurred. code: \(err)")
}