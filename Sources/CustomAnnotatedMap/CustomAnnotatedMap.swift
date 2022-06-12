import SwiftUI

public struct CustomAnnotatedMap<Content>: View where Content: View {

    /// Creates an instance showing a specific region and optionally configuring
    /// available interactions, user location and tracking behavior as well as
    /// annotations.
    ///
    /// - Parameters:
    /// - mapRect: The map rect to display.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - userTrackingMode: How the map should respond to user location updates
    /// - annotationItems: The collection of data backing the annotation views
    /// - annotationContent: A closure producing the annotation content
    public init<Items, Annotation>(
        mapRect: Binding<MapRect>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotationItems: Items,
        @AnnotationBuilder annotationContent: (Items.Element) -> Annotation,
        action annotationDidSelect: @escaping (Items.Element) -> Void = { _ in }
    )
    where
        Content == _CustomAnnotatedMapContent<Items.Element.ID, Annotation>,
        Items: RandomAccessCollection,
        Annotation: MapAnnotationProtocol,
        Items.Element: Identifiable
    {
        let annotations: [Items.Element.ID: Annotation] = Dictionary(
            uniqueKeysWithValues: zip(
                annotationItems.map(\.id),
                annotationItems.map(annotationContent)
            )
        )

        self.content = _CustomAnnotatedMapContent<Items.Element.ID, Annotation>.init(
            mapRect: mapRect,
            showsUserLocation: showsUserLocation,
            userTrackingMode: userTrackingMode,
            annotations: annotations,
            annotationDidSelect: { id in
                if let item = annotationItems.first(where: { $0.id == id }) {
                    annotationDidSelect(item)
                }
            }
        )
    }

    /// Creates an instance showing a specific region and optionally configuring
    /// available interactions, user location and tracking behavior as well as
    /// annotations.
    ///
    /// - Parameters:
    /// - coordinateRegion: The coodinate region to display.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - userTrackingMode: How the map should respond to user location updates
    /// - annotationItems: The collection of data backing the annotation views
    /// - annotationContent: A closure producing the annotation content
    public init<Items, Annotation>(
        coordinateRegion: Binding<CoordinateRegion>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<UserTrackingMode>? = nil,
        annotationItems: Items,
        @AnnotationBuilder annotationContent: (Items.Element) -> Annotation,
        action annotationDidSelect: @escaping (Items.Element) -> Void = { _ in }
    )
    where
        Content == _CustomAnnotatedMapContent<Items.Element.ID, Annotation>,
        Items: RandomAccessCollection,
        Annotation: MapAnnotationProtocol,
        Items.Element: Identifiable
    {
        let annotations: [Items.Element.ID: Annotation] = Dictionary(
            uniqueKeysWithValues: zip(
                annotationItems.map(\.id),
                annotationItems.map(annotationContent)
            )
        )

        self.content = _CustomAnnotatedMapContent<Items.Element.ID, Annotation>.init(
            coordinateRegion: coordinateRegion,
            showsUserLocation: showsUserLocation,
            userTrackingMode: userTrackingMode,
            annotations: annotations,
            annotationDidSelect: { id in
                if let item = annotationItems.first(where: { $0.id == id }) {
                    annotationDidSelect(item)
                }
            }
        )
    }

    private let content: Content

    public var body: some View { content }
}
