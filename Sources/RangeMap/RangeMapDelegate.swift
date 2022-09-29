//
//  RangeMapDelegate.swift
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import Foundation

public protocol RangeMapDelegate: AnyObject {
    func rangeMap(_ rangeMap: RangeMap, didChangeCoordinate coordinate: CoordinateRange)
}
