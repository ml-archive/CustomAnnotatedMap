import MapKit
import SwiftUI

public struct _CustomAnnotatedMapContent<ID, Annotation>: UIViewRepresentable
where
    ID: Hashable,
    Annotation: MapAnnotationProtocol
{
    let annotations: [ID: Annotation]
    @Binding var mapRect: MapRect?
    @Binding var coordinateRegion: CoordinateRegion?
    private let showsUserLocation: Bool
    @Binding var userTrackingMode: UserTrackingMode
    var annotationDidSelect: (ID) -> Void = { _ in }

    typealias CustomAnnotationView = _CustomAnnotationView<
        Annotation.Content,
        Annotation.ContentCluster
    >

    typealias CustomClusterAnnotationView = _CustomClusterAnnotationView<
        Annotation.Content,
        Annotation.ContentCluster
    >

    public init(
        mapRect: Binding<MapRect>,
        userTrackingMode: Binding<UserTrackingMode>?,
        annotations: [ID: Annotation],
        showsUserLocation: Bool
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
        self.annotations = annotations
        self.showsUserLocation = showsUserLocation
        self._userTrackingMode = userTrackingMode ?? .constant(.none)
    }

    public init(
        coordinateRegion: Binding<CoordinateRegion>,
        annotations: [ID: Annotation],
        showsUserLocation: Bool,
        userTrackingMode: Binding<UserTrackingMode>?,
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
        self._userTrackingMode = userTrackingMode ?? .constant(.none)
        self.annotations = annotations
        self.annotationDidSelect = annotationDidSelect
        self.showsUserLocation = showsUserLocation
    }

    public func makeCoordinator() -> _CustomAnnotatedMapCoordinator {
        _CustomAnnotatedMapCoordinator(self)
    }

    public func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.addAnnotations(
            annotations
                .mapValues(\.mkAnnotation)
                .compactMap { $0.value as? MKAnnotation }
        )
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
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = self.showsUserLocation

        // TODO: consider making more convenient the access to rawValue
        if let userTrackingMode = MKUserTrackingMode(
            rawValue: self.userTrackingMode.rawValue
        ) {
            mapView.userTrackingMode = userTrackingMode
        }

        if let coordinateRegion = self.coordinateRegion?.rawValue {
            //FIXME: wait for animation to finish
            mapView.setRegion(coordinateRegion, animated: true)
        } else if let coordinateRegion = self.mapRect?.coordinateRegion.rawValue {
            //FIXME: wait for animation to finish
            mapView.setRegion(coordinateRegion, animated: true)
        } else {
            fatalError("Either `coordinateRegion` or `mapRect` must be not nil")
        }
    }
}
