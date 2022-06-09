import CoreLocation
import MapKit
import SwiftUI

public struct MapAnnotation<Content, ContentCluster>: MapAnnotationProtocol
where
    Content: View,
    ContentCluster: View
{
    public let mkAnnotation: _CustomMKAnnotation<Content, ContentCluster>

    /// A customizable annotation that can cluster together that marks a map location
    public init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String,
        anchorPoint: CGPoint = .init(x: 0.5, y: 0.5),
        @ViewBuilder content: () -> Content,
        @ViewBuilder contentCluster: () -> ContentCluster
    ) {
        self.mkAnnotation = _CustomMKAnnotation.init(
            coordinate: coordinate,
            clusteringIdentifier: clusteringIdentifier,
            content: content(),
            contentCluster: contentCluster()
        )
    }
}

extension MapAnnotation
where
    Content: View,
    ContentCluster == Never
{
    /// A customizable single annotation hat marks a map location
    public init(
        coordinate: CLLocationCoordinate2D,
        anchorPoint: CGPoint = .init(x: 0.5, y: 0.5),
        @ViewBuilder content: () -> Content
    ) {
        self.mkAnnotation = _CustomMKAnnotation.init(
            coordinate: coordinate,
            content: content()
        )
    }
}
