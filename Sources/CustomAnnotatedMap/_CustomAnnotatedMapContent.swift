import MapKit
import SwiftUI

public struct _CustomAnnotatedMapContent<Annotation>: UIViewRepresentable
where Annotation: MapAnnotationProtocol {
    private var annotations: [Annotation]
    @Binding var coordinateRegion: CoordinateRegion
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
        self._coordinateRegion = mapRect.coordinateRegion
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
        mapView.setRegion(coordinateRegion.rawValue, animated: true)
        mapView.showsUserLocation = self.showsUserLocation
    }
}
