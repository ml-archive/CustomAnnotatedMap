import Foundation
import MapKit
import SwiftUI

extension _CustomAnnotatedMapContent {
    public class _CustomAnnotatedMapCoordinator: NSObject, MKMapViewDelegate {
        private var mapContent: _CustomAnnotatedMapContent

        init(_ mapContent: _CustomAnnotatedMapContent<Annotation>) {
            self.mapContent = mapContent
            super.init()
        }

        //MARK: - MKMapViewDelegate
        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.mapContent.coordinateRegion = CoordinateRegion(rawValue: mapView.region)
            self.mapContent.mapRect = MapRect.init(rawValue: mapView.visibleMapRect)
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
    }
}
