import SwiftUI

public struct MapAnnotation<Content, SelectedContent, ContentCluster>: MapAnnotationProtocol
where
    Content: View,
    SelectedContent: View,
    ContentCluster: View
{
    public let mkAnnotation: _CustomMKAnnotation<Content, SelectedContent, ContentCluster>

    /// A customizable annotation that can cluster together that marks a map location
    public init(
        location: Location,
        clusteringIdentifier: String,
        anchorPoint: CGPoint = .init(x: 0.5, y: 0.5),
        @ViewBuilder content: () -> Content,
        @ViewBuilder selectedContent: () ->	SelectedContent,
        @ViewBuilder contentCluster: () -> ContentCluster
    ) {
        self.mkAnnotation = _CustomMKAnnotation.init(
            coordinate: location.coordinate,
            clusteringIdentifier: clusteringIdentifier,
            anchorPoint: anchorPoint,
            content: content(),
            selectedContent: selectedContent(),
            contentCluster: contentCluster()
        )
    }
}

extension MapAnnotation
where
    Content: View,
    SelectedContent: View,
    ContentCluster == Never
{
    /// A customizable single annotation hat marks a map location
    public init(
        location: Location,
        anchorPoint: CGPoint = .init(x: 0.5, y: 0.5),
        @ViewBuilder content: () -> Content,
        @ViewBuilder selectedContent: () -> SelectedContent
    ) {
        self.mkAnnotation = _CustomMKAnnotation.init(
            coordinate: location.coordinate,
            anchorPoint: anchorPoint,
            content: content(),
            selectedContent: selectedContent()
        )
    }
}
