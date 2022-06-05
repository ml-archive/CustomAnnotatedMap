import CoreLocation
import SwiftUI

public protocol MapClusterAnnotationProtocol {
}

public struct MapClusterMarker: MapClusterAnnotationProtocol {
    var annotation: CustomAnnotation

    public init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String,
        tint: Color?
    ) {
        if let tint = tint {
            self.annotation = CustomAnnotation(
                coordinate: coordinate,
                clusteringIdentifier: clusteringIdentifier,
                tint: UIColor(tint)
            )
        } else {
            self.annotation = CustomAnnotation(
                coordinate: coordinate,
                clusteringIdentifier: clusteringIdentifier
            )
        }
    }
}
