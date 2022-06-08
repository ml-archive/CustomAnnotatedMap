import MapKit
import SwiftUI

public protocol MapAnnotationProtocol {

    associatedtype Annotation = MKAnnotation

    associatedtype Content: View
    associatedtype ContentCluster: View

    var mkAnnotation: Annotation { get }
}
