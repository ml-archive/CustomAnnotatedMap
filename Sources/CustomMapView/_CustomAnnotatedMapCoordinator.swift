import Foundation
import MapKit

extension _CustomAnnotatedMapContent {
    public class _CustomAnnotatedMapCoordinator:
        NSObject,
        MKMapViewDelegate,
        CLLocationManagerDelegate
    {
        var locationManager = CLLocationManager()
        private var mapContent: _CustomAnnotatedMapContent

        init(_ control: _CustomAnnotatedMapContent<Annotation>) {
            self.mapContent = control
            super.init()
            self.locationManager.delegate = self
        }

        //MARK: - MKMapViewDelegate
        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.mapContent.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
        }

        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
            -> MKAnnotationView?
        {
            var annotationView: MKAnnotationView?

            if let annotation = annotation as? CustomAnnotation {
                annotationView = setupDefaultAnnotationView(
                    for: annotation,
                    on: mapView
                )
            }

            return annotationView
        }

        //MARK: - CLLocationManagerDelegate
        public func locationManager(
            _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
        ) {
            guard let center = locations.last?.coordinate else { return }
            self.mapContent.coordinateRegion = CoordinateRegion.init(
                center: center,
                span: .init(
                    latitudeDelta: 30,
                    longitudeDelta: 30
                )
            )
        }
    }
}

// MARK: Setup Annotation View
extension _CustomAnnotatedMapContent._CustomAnnotatedMapCoordinator {
    fileprivate func setupDefaultAnnotationView(
        for annotation: CustomAnnotation,
        on mapView: MKMapView
    ) -> MKAnnotationView {
        let identifier = NSStringFromClass(CustomAnnotation.self)
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier,
            for: annotation
        )

        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            // markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.markerTintColor = annotation.tint
            markerAnnotationView.clusteringIdentifier = annotation.clusteringIdentifier

            // Provide an image view to use as the accessory view's detail view.
            // markerAnnotationView.detailCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "ferry_building"))
        }

        return view
    }
}
