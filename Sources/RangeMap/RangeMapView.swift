//
//  ResisableMapView.swift
//
//  Created by Matsunaka Shigeki on 2022/09/29.
//

import SwiftUI

public struct RangeMapView: UIViewRepresentable {
    @Binding private var coordinate: CoordinateRange
    
    public init(coordinate: Binding<CoordinateRange>) {
        self._coordinate = coordinate
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> RangeMap {
        let rangeMap = RangeMap()
        rangeMap.delegate = context.coordinator
        rangeMap.setCoordinate(to: coordinate, animated: false)
        return rangeMap
    }
    
    public func updateUIView(_ uiView: RangeMap, context: Context) {
        if !uiView.coordinate.isEqual(to: coordinate) {
            uiView.setCoordinate(to: coordinate, animated: true)
        }
    }
    
    public class Coordinator: RangeMapDelegate {
        let parent: RangeMapView
        
        init(_ parent: RangeMapView) {
            self.parent = parent
        }
        
        public func rangeMap(_ rangeMap: RangeMap, didChangeCoordinate coordinate: CoordinateRange) {
            parent.coordinate = coordinate
        }
    }
}

extension CoordinateRange {
    func isEqual(to coordinate: CoordinateRange) -> Bool {
        center.distance(to: coordinate.center).isZero && radius.isEqual(to: coordinate.radius)
    }
}

struct RangeMapView_Previews: PreviewProvider {
    static var previews: some View {
        RangeMapView(coordinate: .constant(.init(center: .init(), radius: 100)))
    }
}
