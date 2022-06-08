import MapKit
import SwiftUI

public class _CustomMKAnnotation<Content, ContentCluster>: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic public var coordinate: CLLocationCoordinate2D

    let clusteringIdentifier: String?
    let content: Content?
    let contentCluster: ContentCluster?
    //TODO: implement "selected view"

    init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String? = nil,
        content: Content,
        contentCluster: ContentCluster? = nil
    ) {
        self.coordinate = coordinate
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content
        self.contentCluster = contentCluster
        super.init()
    }
}

// MARK: - Single View

class _CustomAnnotationView<Content, ContentCluster>: MKAnnotationView
where
    Content: View,
    ContentCluster: View
{
    private var content: Content

    typealias CustomMKAnnotation = _CustomMKAnnotation<Content, ContentCluster>

    init(annotation: MKAnnotation) {
        guard
            let customMKAnnotation = annotation as? CustomMKAnnotation,
            let content = customMKAnnotation.content
        else {
            fatalError(
                """
                - _CustomClusterAnnotationView must be used only with `_CustomMKAnnotation`
                - `_CustomMKAnnotation` must have <Content> assigned
                """
            )
        }
        self.content = content

        //TODO: set frame from content

        super.init(
            annotation: customMKAnnotation,
            reuseIdentifier: "customAnnotationViewReuseIdentifier"
        )
        self.clusteringIdentifier = customMKAnnotation.clusteringIdentifier
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.image = self.content.snapshot()
        // self.frame = .init(origin: .zero, size: .init(width: 22, height: 22))
    }
}

// MARK: - Cluster View

class _CustomClusterAnnotationView<Content, ContentCluster>: MKAnnotationView
where
    Content: View,
    ContentCluster: View
{
    private var content: ContentCluster

    typealias CustomMKAnnotation = _CustomMKAnnotation<Content, ContentCluster>

    init(cluster: MKClusterAnnotation) {
        guard
            let members = cluster.memberAnnotations as? [CustomMKAnnotation],
            let content = members.first?.contentCluster
        else {
            fatalError(
                """
                - _CustomClusterAnnotationView must be used only with `MKClusterAnnotation`
                - `MKClusterAnnotation.memberAnnotations` must be of type `[CustomMKAnnotation]`
                - `_CustomMKAnnotation` must have <ContentCluster> assigned
                """
            )
        }
        self.content = content
        super.init(
            annotation: cluster,
            reuseIdentifier: "customClusterAnnotationViewReuseIdentifier"
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.image = self.content.snapshot()
    }
}
