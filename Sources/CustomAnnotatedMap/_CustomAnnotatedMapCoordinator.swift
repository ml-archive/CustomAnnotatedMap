import Foundation
import MapKit
import SwiftUI

extension _CustomAnnotatedMapContent {
    public class _CustomAnnotatedMapCoordinator: NSObject, MKMapViewDelegate {
        private var mapContent: _CustomAnnotatedMapContent

        init(_ mapContent: _CustomAnnotatedMapContent<ID, Annotation>) {
            self.mapContent = mapContent
            super.init()
        }

        public func mapView(
            _ mapView: MKMapView,
            regionDidChangeAnimated animated: Bool
        ) {
            self.mapContent.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
            self.mapContent.mapRect = MapRect.init(rawValue: mapView.visibleMapRect)
        }

        public func mapView(
            _ mapView: MKMapView,
            viewFor annotation: MKAnnotation
        ) -> MKAnnotationView? {
            if let cluster = annotation as? MKClusterAnnotation {
                return CustomClusterAnnotationView(cluster: cluster)
            } else {
                return CustomAnnotationView(annotation: annotation)
            }
        }

        public func mapView(
            _ mapView: MKMapView,
            didSelect view: MKAnnotationView
        ) {
            let annotation = self.mapContent.annotations
                .mapValues { $0.mkAnnotation as? MKAnnotation }
                .first { $0.value?.coordinate == view.annotation?.coordinate }

            guard let id = annotation?.key else { return }
            self.mapContent.annotationDidSelect(id)
        }

        // MARK: - Tracking the User Location
        public func mapView(
            _ mapView: MKMapView,
            didUpdate userLocation: MKUserLocation
        ) {
            //
        }
        public func mapView(
            _ mapView: MKMapView,
            didChange mode: MKUserTrackingMode,
            animated: Bool
        ) {
            if let userTrackingMode = UserTrackingMode(rawValue: mode.rawValue) {
                self.mapContent.userTrackingMode = userTrackingMode
            }
        }
    }
}
