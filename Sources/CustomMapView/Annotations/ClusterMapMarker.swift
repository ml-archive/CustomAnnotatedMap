import CoreLocation
import SwiftUI

/// A balloon-shaped annotation that marks a map location.
public struct ClusterMapMarker: ClusterMapAnnotationProtocol {
    var annotation: _BaseMKAnnotation

    public init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String,
        tint: Color?
    ) {
        if let tint = tint {
            self.annotation = .init(
                coordinate: coordinate,
                clusteringIdentifier: clusteringIdentifier,
                tint: UIColor(tint)
            )
        } else {
            self.annotation = .init(
                coordinate: coordinate,
                clusteringIdentifier: clusteringIdentifier
            )
        }
    }
}
