import MapKit
import SwiftUI

public class _CustomMKAnnotation<Content, SelectedContent, ContentCluster>: NSObject, MKAnnotation {

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic public var coordinate: CLLocationCoordinate2D

    let clusteringIdentifier: String?
    let content: Content
    let selectedContent: SelectedContent?
    let contentCluster: ContentCluster?
    let anchorPoint: CGPoint

    init(
        coordinate: CLLocationCoordinate2D,
        clusteringIdentifier: String? = nil,
        anchorPoint: CGPoint,
        content: Content,
        selectedContent: SelectedContent,
        contentCluster: ContentCluster? = nil
    ) {
        self.anchorPoint = anchorPoint
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
        notSelectedView.backgroundColor = .clear
        selectedView.backgroundColor = .clear
        
        super.init(
            annotation: customMKAnnotation,
            reuseIdentifier: "customAnnotationViewReuseIdentifier"
        )
        
        self.clusteringIdentifier = customMKAnnotation.clusteringIdentifier
        frame = CGRect(x: 0, y: 0, width: 30, height: 40)

        centerOffset = CGPoint(x: 0, y: -frame.size.height)
        addSubview(notSelectedView)
        notSelectedView.frame = bounds
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // Toogles the selection views
        if selected {
            addSubview(selectedView)
            selectedView.frame = bounds
        } else {
            addSubview(notSelectedView)
            notSelectedView.frame = bounds
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
