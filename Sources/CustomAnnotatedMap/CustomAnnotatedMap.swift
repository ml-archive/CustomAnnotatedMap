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
        annotationContent: @escaping (Items.Element) -> Annotation,
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
            annotations: annotations,
            showsUserLocation: showsUserLocation,
            annotationDidSelect: { id in
                if let item = annotationItems.first(where: { $0.id == id }) {
                    annotationDidSelect(item)
                }
            }
        )
    }

    public var body: some View { content }
}
