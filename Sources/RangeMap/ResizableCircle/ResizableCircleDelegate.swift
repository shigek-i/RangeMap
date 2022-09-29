//
//  ResizableCircleDelegate.swift
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import Foundation

protocol ResizableCircleDelegate: AnyObject {
    func resizableCircleDidChangeRadius(_ resizableCircle: ResizableCircle)
    func resizableCircleDidEndChangingRadius(_ resizableCircle: ResizableCircle)
}
