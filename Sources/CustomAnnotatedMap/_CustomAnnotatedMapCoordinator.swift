import Foundation
import MapKit
import SwiftUI

extension _CustomAnnotatedMapContent {
    public class _CustomAnnotatedMapCoordinator:
        NSObject,
        MKMapViewDelegate,
        CLLocationManagerDelegate
    {
        var locationManager = CLLocationManager()
        private var mapContent: _CustomAnnotatedMapContent

        init(_ mapContent: _CustomAnnotatedMapContent<Annotation>) {
            self.mapContent = mapContent
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
            if let cluster = annotation as? MKClusterAnnotation {
                return CustomClusterAnnotationView(cluster: cluster)
            } else {
                return CustomAnnotationView(annotation: annotation)
            }
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
