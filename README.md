# RangeMap

A map that allows users to set `latitude` and `longitude` and `range` with a circle like Reminder app does.

![screen_resized](https://user-images.githubusercontent.com/34618251/193068663-0dd52067-bb91-4b61-93a3-9c52fb905a3a.gif)

## Requirements
iOS 14.0+

## Installation
### Swift Package Manager
In Xcode, select `File` -> `Add Packages...`

Enter https://github.com/shigek-i/RangeMap.git into the text field.

## How to use
### SwiftUI
```swift
import SwiftUI
import RangeMap

struct TestView: View {
    @State private var coordinate = CoordinateRange(
        center: .init(latitude: 37.33464271277836, longitude: -122.00896990779975),
        radius: 1000
    )
    
    var body: some View {
        RangeMapView(coordinate: $coordinate)
    }
}
```


### UIKit
```swift
import UIKit
import RangeMap

class ViewController: UIViewController {
    private var coordinate = CoordinateRange(
        center: .init(latitude: 37.33464271277836, longitude: -122.00896990779975),
        radius: 1000
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let rangeMap = RangeMap()
        rangeMap.setCoordinate(to: coordinate, animated: false)
        
        rangeMap.frame = view.frame
        view.addSubview(rangeMap)
    }
}

extension ViewController: RangeMapDelegate {
    func rangeMap(_ rangeMap: RangeMap, didChangeCoordinate coordinate: CoordinateRange) {
        self.coordinate = coordinate
    }
}
```
