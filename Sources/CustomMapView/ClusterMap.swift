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

// MARK: -

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
