import MapKit
import SwiftUI

public protocol MapAnnotationProtocol {

    associatedtype Annotation = MKAnnotation

    associatedtype Content: View
    associatedtype SelectedContent: View
    associatedtype ContentCluster: View

    var mkAnnotation: Annotation { get }
}

@resultBuilder
public struct AnnotationBuilder {

    public static func buildBlock<Annotation>(_ annotation: Annotation) -> Annotation
    where Annotation: MapAnnotationProtocol {
        return annotation
    }

    public static func buildEither<Annotation>(first: Annotation) -> Annotation
    where Annotation: MapAnnotationProtocol {
        return first
    }

    public static func buildEither<Annotation>(second: Annotation) -> Annotation
    where Annotation: MapAnnotationProtocol {
        return second
    }
}
