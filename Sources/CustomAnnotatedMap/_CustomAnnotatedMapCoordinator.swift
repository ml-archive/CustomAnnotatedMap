import Foundation
import MapKit
import SwiftUI

extension _CustomAnnotatedMapContent {

    public class _CustomAnnotatedMapCoordinator: NSObject, MKMapViewDelegate {
        private var mapContent: _CustomAnnotatedMapContent
        /// Determines if changes in map region are updated to the mapContent view
        var listenToLocationChanges = false
        
        /// The latest map region that got updated to the mapContent view
        var lastMapRect: MapRect?
        
        /// The IDs of the annotations currently displayed in the mapContent view
        var displayedAnnotationsIDs: Set<ID> = []

        init(_ mapContent: _CustomAnnotatedMapContent<ID, Annotation>) {
            self.mapContent = mapContent
            super.init()
        }

        public func mapView(
            _ mapView: MKMapView,
            regionDidChangeAnimated animated: Bool
        ) {
            /*
              Only update the map region changes to the mapContent if allowed.
              This prevents updates during the manual changes to the map region and user tracking mode
              which are animated and would be interrupted.
             */
            guard listenToLocationChanges else { return }
            
            self.mapContent.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
            self.mapContent.mapRect = MapRect.init(rawValue: mapView.visibleMapRect)
            self.lastMapRect = MapRect.init(rawValue: mapView.visibleMapRect)
        }

        public func mapView(
            _ mapView: MKMapView,
            viewFor annotation: MKAnnotation
        ) -> MKAnnotationView? {
            if let cluster = annotation as? MKClusterAnnotation {
                return CustomClusterAnnotationView(cluster: cluster)
            } else if let annotation = annotation as? CustomMKAnnotation {
                return CustomAnnotationView(annotation: annotation)
            } else if let annotation = annotation as? MKUserLocation {
                // This is done automatically by `MapKit` but expressed explicitly for clarity
                return MKUserLocationView(annotation: annotation, reuseIdentifier: nil)
            } else {
                return nil
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
            didChange mode: MKUserTrackingMode,
            animated: Bool
        ) {
            if let userTrackingMode = UserTrackingMode(rawValue: mode.rawValue) {
                self.mapContent.userTrackingMode = userTrackingMode
            }
        }
    }

}
