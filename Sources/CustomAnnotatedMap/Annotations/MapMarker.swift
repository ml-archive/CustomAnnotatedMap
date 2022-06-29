import SwiftUI

/// A balloon-shaped annotation that marks a map location.
public struct MapMarker: MapAnnotationProtocol {
    public typealias Content = Never
    public typealias SelectedContent = Never
    public typealias ContentCluster = Never

    public let mkAnnotation: _BaseMKAnnotation

    public init(
        location: Location,
        clusteringIdentifier: String? = nil,
        tint: Color? = nil
    ) {
        self.mkAnnotation = _BaseMKAnnotation.init(
            coordinate: location.coordinate,
            clusteringIdentifier: clusteringIdentifier,
            tint: tint
        )
    }
}
