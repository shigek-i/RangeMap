//
//  RangeMap.swift
//
//  Created by Matsunaka Shigeki on 2022/09/23.
//

import MapKit

public class RangeMap: UIView {
    private let mapView: MKMapView = .init()
    private let scalableCircle = ResizableCircle()
    private let annotation: MKPointAnnotation = .init()
    private(set) var coordinate: CoordinateRange = .init(center: .init(), radius: 100)
    
    weak var delegate: RangeMapDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public func setCoordinate(to coordinate: CoordinateRange, animated: Bool) {
        self.coordinate = coordinate
        updateCircle()
        adjustVisibleResion(animated: animated)
        updateAnnotation()
    }
    
    private func commonInit() {
        var constraints: [NSLayoutConstraint] = []
        
        // MapView
        mapView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onTapGesture(sender:))
            )
        )
        mapView.delegate = self
        mapView.addAnnotation(annotation)
        
        addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        constraints += [
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        // ScalableCircle
        scalableCircle.delegate = self
        
        // _MKMapContentViewにaddする
        mapView.subviews.first?.addSubview(scalableCircle)
        scalableCircle.translatesAutoresizingMaskIntoConstraints = false
        constraints += [
            scalableCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            scalableCircle.trailingAnchor.constraint(equalTo: trailingAnchor),
            scalableCircle.topAnchor.constraint(equalTo: topAnchor),
            scalableCircle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

private extension RangeMap {
    @objc func onTapGesture(sender: UITapGestureRecognizer) {
        let tappedLocation = sender.location(in: mapView)
        let nextCenter = mapView.convert(
            .init(x: tappedLocation.x, y: tappedLocation.y),
            toCoordinateFrom: mapView
        )
        
        coordinate.center = nextCenter
        annotation.coordinate = nextCenter
        
        updateCircle()
        adjustVisibleResion(animated: true)
        updateAnnotation()
        
        delegate?.rangeMap(self, didChangeCoordinate: coordinate)
    }
    
    func updateAnnotation() {
        annotation.coordinate = coordinate.center
    }
    
    func updateCircle() {
        let rect = mapView.convert(coordinate.region, toRectTo: mapView)
        scalableCircle.circleCenter = .init(x: rect.midX, y: rect.midY)
        scalableCircle.radius = rect.width/2
        updateLabel()
        scalableCircle.isHidden = false
    }
    
    func updateLabel() {
        let label: String
        if coordinate.radius < 1000 {
            label = "\(round(coordinate.radius*10)/10) m"
        } else {
            label = "\(round(coordinate.radius/100)/10) km"
        }
        scalableCircle.label = label
    }
    
    func adjustVisibleResion(animated: Bool) {
        mapView.setRegion(CoordinateRange(center: coordinate.center, radius:coordinate.radius*1.6).region, animated: animated)
    }
}

// MARK: - MKMapViewDelegate
extension RangeMap: MKMapViewDelegate {
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        updateCircle()
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach {
            $0.superview?.layer.zPosition = 1
        }
    }
}

// MARK: - ScalableCircleDelegate
extension RangeMap: ResizableCircleDelegate {
    func resizableCircleDidChangeRadius(_ resizableCircle: ResizableCircle) {
        let thumbCoordinate = mapView.convert(
            .init(x: resizableCircle.circleCenter.x + resizableCircle.radius, y: resizableCircle.circleCenter.y),
            toCoordinateFrom: mapView
        )
        let distance = coordinate.center.distance(to: thumbCoordinate)
        let nextCircleCoordinate: CoordinateRange = .init(center: coordinate.center, radius: distance)
        coordinate = nextCircleCoordinate
        updateLabel()
        
        delegate?.rangeMap(self, didChangeCoordinate: nextCircleCoordinate)
    }
    
    func resizableCircleDidEndChangingRadius(_ resizableCircle: ResizableCircle) {
        adjustVisibleResion(animated: true)
    }
}
