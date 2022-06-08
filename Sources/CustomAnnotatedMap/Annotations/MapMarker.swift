import CoreLocation
import SwiftUI

/// A balloon-shaped annotation that marks a map location.
public struct MapMarker: MapAnnotationProtocol {
    public typealias Content = Never
    public typealias ContentCluster = Never

    public let mkAnnotation: _BaseMKAnnotation

    public init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String? = nil,
        tint: Color? = nil
    ) {
        self.mkAnnotation = _BaseMKAnnotation.init(
            coordinate: coordinate,
            clusteringIdentifier: clusteringIdentifier,
            tint: tint
        )
    }
}
