//
//  CLLocationCoordinate2DExtension.swift
//
//  Created by Matsunaka Shigeki on 2022/03/13.
//

import MapKit

extension CLLocationCoordinate2D {
    func distance( to targetLocation: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(
            latitude: latitude,
            longitude: longitude
        )
        let location2 = CLLocation(
            latitude: targetLocation.latitude,
            longitude: targetLocation.longitude
        )
        return location1.distance(from: location2)
    }
}
