import MapKit
import SwiftUI

public struct ClusterMap<Content>: View where Content: View {
    private let content: Content

    /// - Parameters:
    /// - mapRect: The map rect to display.
    /// - interactions: The types of user interactions that should be enabled.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - userTrackingMode: How the map should respond to user location updates
    /// - annotationItems: The collection of data backing the annotation views
    /// - annotationContent: A closure producing the annotation content
    public init<Items, Annotation>(
        mapRect: Binding<MapRect>,
        interactionModes: MapInteractionModes = .all,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>? = nil,
        annotationItems: Items,
        annotationContent: @escaping (Items.Element) -> Annotation
    )
    where
        Content == _CustomAnnotatedMapContent<Annotation>,
        Items: RandomAccessCollection,
        Annotation: MapClusterAnnotationProtocol,
        Items.Element: Identifiable
    {
        let annotations = annotationItems.map(annotationContent)
        self.content = _CustomAnnotatedMapContent<Annotation>.init(
            mapRect: mapRect,
            annotations: annotations,
            interactionModes: interactionModes,
            showsUserLocation: showsUserLocation
        )
    }

    public var body: some View { content }
}
