import MapKit
import SwiftUI

public struct _CustomAnnotatedMapContent<ID, Annotation>: UIViewRepresentable
where
    ID: Hashable,
    Annotation: MapAnnotationProtocol
{
    typealias CustomMKAnnotation = _CustomMKAnnotation<
        Annotation.Content,
        Annotation.SelectedContent,
        Annotation.ContentCluster
    >

    typealias CustomAnnotationView = _CustomAnnotationView<
        Annotation.Content,
        Annotation.SelectedContent,
        Annotation.ContentCluster
    >

    typealias CustomClusterAnnotationView = _CustomClusterAnnotationView<
        Annotation.Content,
        Annotation.SelectedContent,
        Annotation.ContentCluster
    >

    @Binding var mapRect: MapRect?
    @Binding var coordinateRegion: CoordinateRegion?

    private let showsUserLocation: Bool
    @Binding var userTrackingMode: UserTrackingMode
    let annotations: [ID: Annotation]
    var annotationDidSelect: (ID) -> Void = { _ in }

    public init(
        mapRect: Binding<MapRect>,
        showsUserLocation: Bool,
        userTrackingMode: Binding<UserTrackingMode>?,
        annotations: [ID: Annotation],
        annotationDidSelect: @escaping (ID) -> Void
    ) {
        self._mapRect = Binding(
            get: { .some(mapRect.wrappedValue) },
            set: {
                if let value = $0 {
                    mapRect.wrappedValue = value
                }
            }
        )
        self._coordinateRegion = .constant(.none)
        self.showsUserLocation = showsUserLocation
        self._userTrackingMode = userTrackingMode ?? .constant(.none)
        self.annotations = annotations
        self.annotationDidSelect = annotationDidSelect
    }

    public init(
        coordinateRegion: Binding<CoordinateRegion>,
        showsUserLocation: Bool,
        userTrackingMode: Binding<UserTrackingMode>?,
        annotations: [ID: Annotation],
        annotationDidSelect: @escaping (ID) -> Void
    ) {
        self._mapRect = .constant(.none)
        self._coordinateRegion = Binding(
            get: { .some(coordinateRegion.wrappedValue) },
            set: {
                if let value = $0 {
                    coordinateRegion.wrappedValue = value
                }
            }
        )
        self.showsUserLocation = showsUserLocation
        self._userTrackingMode = userTrackingMode ?? .constant(.none)
        self.annotations = annotations
        self.annotationDidSelect = annotationDidSelect
    }

    public func makeCoordinator() -> _CustomAnnotatedMapCoordinator {
        _CustomAnnotatedMapCoordinator(self)
    }

    public func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        updateAnnotationsIfNeeded(on: mapView,
                                  with: context.coordinator)
        
        mapView.register(
            CustomAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )

        mapView.register(
            CustomClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier:
                MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
        return mapView
    }

    public func updateUIView(_ mapView: UIViewType, context: Context) {
        
        if mapView.delegate == nil {
            mapView.delegate = context.coordinator
        }
        
        updateAnnotationsIfNeeded(on: mapView,
                                  with: context.coordinator)
        
        if mapView.showsUserLocation != self.showsUserLocation {
            mapView.showsUserLocation = self.showsUserLocation
        }

        if let userTrackingMode = MKUserTrackingMode(rawValue: self.userTrackingMode.rawValue),
            mapView.userTrackingMode != userTrackingMode
        {
            performWithoutLocationUpdates(on: context.coordinator) {
                mapView.setUserTrackingMode(userTrackingMode, animated: true)
            }
        }

        // Update the map region either using the coordinateRegion or MapRect
        if let coordinateRegion = self.coordinateRegion {
            updateRegion(coordinateRegion,
                          on: mapView,
                          with: context.coordinator)
        } else if let mapRect = self.mapRect {
            updateRegion(mapRect.coordinateRegion,
                          on: mapView,
                          with: context.coordinator)
        } else {
            fatalError("Either mapRect or coordinateRegion should be set")
        }
    }
    
    
    /// Checks if the current annotations reflect the annotations displayed in the map and updates accordingly
    /// - Parameters:
    ///   - mapView: The MKMapView associated with this UIViewRepresentable
    ///   - coordinator: The associated coordinator object
    private func updateAnnotationsIfNeeded(on mapView: MKMapView, with coordinator: Coordinator) {
        let annotationsIds = Set(annotations.map { $0.key})
        
        if coordinator.displayedAnnotationsIDs != annotationsIds {
            mapView.removeAnnotations(mapView.annotations)
            
            mapView.addAnnotations(
                annotations
                    .mapValues(\.mkAnnotation)
                    .compactMap { $0.value as? MKAnnotation }
            )
            
            coordinator.displayedAnnotationsIDs = annotationsIds
        }
    }
    
    /// Moves the map to a coordinate region
    /// - Parameters:
    ///   - coordinateRegion: The region the map will be moved to
    ///   - mapView: The MKMapView associated with this UIViewRepresentable
    ///   - coordinator: The associated coordinator object
    private func updateRegion(_ coordinateRegion: CoordinateRegion, on mapView: UIViewType, with coordinator: Coordinator) {
            // Prevents repetitive calls to MKMapView.setRegion when other parts of the view are updated that are not
            // related to the map region
            guard !coordinateRegion.mapRect.isSame(as: coordinator.lastMapRect) else {
                return
            }
            
            performWithoutLocationUpdates(on: coordinator) {
                mapView.setRegion(coordinateRegion.rawValue, animated: true)
            }
    }
    
    /// Pauses the location updates on the coordinator while performing a task
    /// - Parameters:
    ///   - coordinator: The associated Coordinator object
    ///   - task: The task to be performed
    private func performWithoutLocationUpdates(on coordinator: _CustomAnnotatedMapCoordinator, task: () -> Void) {
        defer {
            coordinator.listenToLocationChanges = true
        }
        
        coordinator.listenToLocationChanges = false
        task()
    }
}
