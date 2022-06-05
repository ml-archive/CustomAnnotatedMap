import Foundation
import MapKit
import SwiftUI

public struct CustomMapView: UIViewRepresentable {
    @Binding fileprivate var coordinateRegion: CoordinateRegion
    private let interactionModes: MapInteractionModes
    private let showsUserLocation: Bool
    private var userTrackingMode: Binding<MapUserTrackingMode>?

    /// Creates an instance showing a specific region and optionally configuring
    /// available interactions, user location and tracking behavior.
    ///
    /// - Parameters:
    /// - coordinateRegion: The coordinate region to display.
    /// - interactions: The types of user interactions that should be enabled.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - userTrackingMode: How the map should respond to user location updates
    public init(
        coordinateRegion: Binding<CoordinateRegion>,
        interactionModes: MapInteractionModes = .all,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>? = nil
    ) {
        self._coordinateRegion = coordinateRegion
        self.interactionModes = interactionModes
        self.showsUserLocation = showsUserLocation
        self.userTrackingMode = userTrackingMode
    }

    /// Creates an instance showing a specific region and optionally configuring
    /// available interactions, user location and tracking behavior.
    ///
    /// - Parameters:
    /// - mapRect: The map rect to display.
    /// - interactions: The types of user interactions that should be enabled.
    /// - showsUserLocation: Whether to display the user's location in this Map
    ///   or not. Only takes effect if the user has authorized the app to access
    ///   their location.
    /// - userTrackingMode: How the map should respond to user location updates
    public init(
        mapRect: Binding<MapRect>,
        interactionModes: MapInteractionModes = .all,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>? = nil
    ) {
        self._coordinateRegion = mapRect.coordinateRegion
        self.interactionModes = interactionModes
        self.showsUserLocation = showsUserLocation
        self.userTrackingMode = userTrackingMode
    }

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
    where /* Content == _DefaultAnnotatedMapContent<Items>, */
        Items: RandomAccessCollection,
        Annotation: MapAnnotationProtocol,
        Items.Element: Identifiable
    {
        self.init(
            mapRect: mapRect,
            interactionModes: interactionModes,
            showsUserLocation: showsUserLocation,
            userTrackingMode: userTrackingMode
        )

        //TODO: create annotations

        // let n = annotationItems.map { item in
        //     return annotationContent(item)
        // }
        let n = annotationItems.map(annotationContent)  // [Annotation]
        let j = n.map { $0 as! MapMarker }

        let z = MapMarker(coordinate: .init(), tint: .purple)
        // let z2 = MKMarkerAnnotationView
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView(frame: .zero)
        return mapView
    }

    public func updateUIView(_ mapView: UIViewType, context: Context) {
        mapView.delegate = context.coordinator
        mapView.setRegion(coordinateRegion.rawValue, animated: true)

        if self.interactionModes.isEmpty {
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
        } else {
            mapView.isScrollEnabled = self.interactionModes.contains(.pan)
            mapView.isZoomEnabled = self.interactionModes.contains(.zoom)
        }

        mapView.showsUserLocation = self.showsUserLocation

        //TODO: integrate with location permissions module
        if self.showsUserLocation {
            context.coordinator.locationManager.requestWhenInUseAuthorization()
            context.coordinator.locationManager.startUpdatingLocation()
        } else {
            context.coordinator.locationManager.stopUpdatingLocation()
        }

        //TODO: implement annotations
        // let currentlyDisplayedPOIs = mapView.annotations.compactMap {
        //     $0 as? PointOfInterestAnnotation
        // }
        // .map { $0.pointOfInterest }
        //
        // let addedPOIs = Set(pointsOfInterest).subtracting(currentlyDisplayedPOIs)
        // let removedPOIs = Set(currentlyDisplayedPOIs).subtracting(pointsOfInterest)
        //
        // let addedAnnotations = addedPOIs.map(PointOfInterestAnnotation.init(pointOfInterest:))
        // let removedAnnotations = mapView.annotations.compactMap { $0 as? PointOfInterestAnnotation }
        //     .filter { removedPOIs.contains($0.pointOfInterest) }
        //
        // mapView.removeAnnotations(removedAnnotations)
        // mapView.addAnnotations(addedAnnotations)
    }
}

public class Coordinator: NSObject {
    var locationManager = CLLocationManager()
    private var mapView: CustomMapView

    init(_ control: CustomMapView) {
        self.mapView = control
        super.init()
        self.locationManager.delegate = self
    }

}

extension Coordinator: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
    }
}

extension Coordinator: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //TODO: unimplemented
    }

    public func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        guard let center = locations.last?.coordinate else { return }
        self.mapView.coordinateRegion = CoordinateRegion.init(
            center: center,
            span: .init(
                latitudeDelta: 30,
                longitudeDelta: 30
            )
        )
    }
}
