import MapKit
import SwiftUI

class CustomAnnotation: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D

    private(set) var clusteringIdentifier: String
    private(set) var tint: UIColor?

    init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String,
        tint: UIColor? = nil
    ) {
        self.coordinate = coordinate
        self.clusteringIdentifier = clusteringIdentifier
        self.tint = tint
        super.init()
    }
}
