import MapKit
import SwiftUI

public struct _ClusteredMapContent<Annotation>: UIViewRepresentable {
    private var annotations: [Annotation]
    @Binding var coordinateRegion: CoordinateRegion
    private let interactionModes: MapInteractionModes
    private let showsUserLocation: Bool

    public init(
        mapRect: Binding<MapRect>,
        annotations: [Annotation],
        interactionModes: MapInteractionModes,
        showsUserLocation: Bool
    ) {
        self._coordinateRegion = mapRect.coordinateRegion
        self.annotations = annotations
        self.interactionModes = interactionModes
        self.showsUserLocation = showsUserLocation
    }

    public func makeCoordinator() -> _ClusteredMapCoordinator {
        _ClusteredMapCoordinator(self)
    }

    public func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView(frame: .zero)

        let mkAnnotations =
            annotations
            .compactMap { $0 as? ClusterMapMarker }
            .map(\.annotation)

        mapView.addAnnotations(mkAnnotations)

        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: NSStringFromClass(_BaseMKAnnotation.self)
        )
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
    }
}
