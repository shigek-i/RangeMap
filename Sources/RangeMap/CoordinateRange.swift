//
//  CoordinateRange.swift
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import MapKit

public struct CoordinateRange {
    public var center: CLLocationCoordinate2D
    public var radius: CLLocationDistance
    
    public var region: MKCoordinateRegion {
        .init(center: center, latitudinalMeters: radius*2, longitudinalMeters: radius*2)
    }
    
    public init(center: CLLocationCoordinate2D, radius: CLLocationDistance) {
        self.center = center
        self.radius = radius
    }
}
