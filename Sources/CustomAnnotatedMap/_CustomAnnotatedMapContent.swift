import MapKit
import SwiftUI

public struct _CustomAnnotatedMapContent<Annotation>: UIViewRepresentable
where Annotation: MapAnnotationProtocol {
    private var annotations: [Annotation]
    @Binding var mapRect: MapRect?
    @Binding var coordinateRegion: CoordinateRegion?
    private let showsUserLocation: Bool

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
        annotations: [Annotation],
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
    }

    public init(
        coordinateRegion: Binding<CoordinateRegion>,
        annotations: [Annotation],
        showsUserLocation: Bool
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
        self.annotations = annotations
        self.showsUserLocation = showsUserLocation
    }

    public func makeCoordinator() -> _CustomAnnotatedMapCoordinator {
        _CustomAnnotatedMapCoordinator(self)
    }

    public func makeUIView(context: Context) -> some MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.addAnnotations(
            annotations
                .map(\.mkAnnotation)
                .compactMap { $0 as? MKAnnotation }
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
