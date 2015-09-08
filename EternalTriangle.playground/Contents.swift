//: Playground - noun: a place where people can play

import UIKit
import EternalTriangle

var str = "Hello, playground"
let s = "__A',,2/3"
let m = s.matchesWithPattern("(\\^{0,2}|_{0,2}|=?)([a-g]|[A-G])([',]*)(\\d*(?:/\\d+)?)")
m[3].match
