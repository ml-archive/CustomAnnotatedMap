import Foundation
import MapKit
import SwiftUI

extension _CustomAnnotatedMapContent {

    public class _CustomAnnotatedMapCoordinator: NSObject, MKMapViewDelegate {
        private var mapContent: _CustomAnnotatedMapContent
        /// Determines if the map region is currently being changed with animation (the map is sliding to a new region)
        var regionIsChanging = false
        
        /// The latest map region that got updated to the mapContent view
        var lastMapRect: MapRect?
        
        /// The IDs of the annotations currently displayed in the mapContent view
        var displayedAnnotationsIDs: Set<ID> = []

        init(_ mapContent: _CustomAnnotatedMapContent<ID, Annotation>) {
            self.mapContent = mapContent
            super.init()
        }
        
        /// This delegate method gets called multiple times during the animation of the region change
        public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.mapContent.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
            self.mapContent.mapRect = MapRect.init(rawValue: mapView.visibleMapRect)
            self.lastMapRect = MapRect.init(rawValue: mapView.visibleMapRect)
        }
        
        /// The map view is about to change the visible map region
        public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            regionIsChanging = true
        }

        /// The map view finished changing the visible map region
        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            regionIsChanging = false
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
                DispatchQueue.main.async {                
                    self.mapContent.userTrackingMode = userTrackingMode
                }
            }
        }
    }

}
