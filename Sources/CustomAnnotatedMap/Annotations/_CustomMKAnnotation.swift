import MapKit
import SwiftUI

public class _CustomMKAnnotation<Content, SelectedContent, ContentCluster>: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic public var coordinate: CLLocationCoordinate2D

    let clusteringIdentifier: String?
    let content: Content
    let selectedContent: SelectedContent?
    let contentCluster: ContentCluster?

    init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String? = nil,
        content: Content,
        selectedContent: SelectedContent,
        contentCluster: ContentCluster? = nil
    ) {
        self.coordinate = coordinate
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content
        self.selectedContent = selectedContent
        self.contentCluster = contentCluster
        super.init()
    }
}

// MARK: - Single View

class _CustomAnnotationView<Content, SelectedContent, ContentCluster>: MKAnnotationView
where
    Content: View,
    SelectedContent: View,
    ContentCluster: View
{
    typealias CustomMKAnnotation = _CustomMKAnnotation<Content, SelectedContent, ContentCluster>

    private var notSelectedView: UIView
    private var selectedView: UIView

    init(annotation: MKAnnotation) {
        guard let customMKAnnotation = annotation as? CustomMKAnnotation else {
            fatalError(
                """
                - _CustomClusterAnnotationView must be used only with `_CustomMKAnnotation`
                - `_CustomMKAnnotation` must have <Content> assigned
                """
            )
        }
        self.notSelectedView = UIHostingController(rootView: customMKAnnotation.content.ignoresSafeArea()).view
        self.selectedView = UIHostingController(rootView: customMKAnnotation.selectedContent.ignoresSafeArea()).view
        super.init(
            annotation: customMKAnnotation,
            reuseIdentifier: "customAnnotationViewReuseIdentifier"
        )
        self.clusteringIdentifier = customMKAnnotation.clusteringIdentifier
        self.addSubview(notSelectedView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Toogles the selection views 
        if selected {
            self.addSubview(selectedView)
            notSelectedView.removeFromSuperview()
        } else {
            self.addSubview(notSelectedView)
            selectedView.removeFromSuperview()
        }
    }
}

// MARK: - Cluster View

class _CustomClusterAnnotationView<Content, SelectedContent, ContentCluster>: MKAnnotationView
where
    Content: View,
    SelectedContent: View,
    ContentCluster: View
{
    typealias CustomMKAnnotation = _CustomMKAnnotation<Content, SelectedContent, ContentCluster>

    init(cluster: MKClusterAnnotation) {
        guard
            let members = cluster.memberAnnotations as? [CustomMKAnnotation],
            let contentCluster = members.first?.contentCluster
        else {
            fatalError(
                """
                - _CustomClusterAnnotationView must be used only with `MKClusterAnnotation`
                - `MKClusterAnnotation.memberAnnotations` must be of type `[CustomMKAnnotation]`
                - `_CustomMKAnnotation` must have <ContentCluster> assigned
                """
            )
        }
        super.init(
            annotation: cluster,
            reuseIdentifier: "customClusterAnnotationViewReuseIdentifier"
        )
        self.addSubview(UIHostingController(rootView: contentCluster.ignoresSafeArea()).view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
