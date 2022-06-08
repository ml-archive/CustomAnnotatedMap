import MapKit
import SwiftUI

public class _BaseMKAnnotation: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic public var coordinate: CLLocationCoordinate2D

    let clusteringIdentifier: String?
    let tint: Color?

    init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String?,
        tint: Color?
    ) {
        self.coordinate = coordinate
        self.clusteringIdentifier = clusteringIdentifier
        self.tint = tint
        super.init()
    }
}
