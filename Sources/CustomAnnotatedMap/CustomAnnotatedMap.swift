import MapKit
import SwiftUI

public struct CustomAnnotatedMap<Content>: View where Content: View {
    private let content: Content

    /// - Parameters:
    /// - mapRect: The map rect to display.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - annotationItems: The collection of data backing the annotation views
    /// - annotationContent: A closure producing the annotation content
    public init<Items, Annotation>(
        mapRect: Binding<MapRect>,
        showsUserLocation: Bool = false,
        annotationItems: Items,
        annotationContent: @escaping (Items.Element) -> Annotation
    )
    where
        Content == _CustomAnnotatedMapContent<Annotation>,
        Items: RandomAccessCollection,
        Annotation: MapAnnotationProtocol,
        Items.Element: Identifiable
    {
        let annotations = annotationItems.map(annotationContent)

        self.content = _CustomAnnotatedMapContent<Annotation>.init(
            mapRect: mapRect,
            annotations: annotations,
            showsUserLocation: showsUserLocation
        )
    }

    /// - Parameters:
    /// - coordinateRegion: The coodinate region to display.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - annotationItems: The collection of data backing the annotation views
    /// - annotationContent: A closure producing the annotation content
    public init<Items, Annotation>(
        coordinateRegion: Binding<CoordinateRegion>,
        showsUserLocation: Bool = false,
        annotationItems: Items,
        annotationContent: @escaping (Items.Element) -> Annotation
    )
    where
        Content == _CustomAnnotatedMapContent<Annotation>,
        Items: RandomAccessCollection,
        Annotation: MapAnnotationProtocol,
        Items.Element: Identifiable
    {
        let annotations = annotationItems.map(annotationContent)

        self.content = _CustomAnnotatedMapContent<Annotation>.init(
            coordinateRegion: coordinateRegion,
            annotations: annotations,
            showsUserLocation: showsUserLocation
        )
    }

    public var body: some View { content }
}
