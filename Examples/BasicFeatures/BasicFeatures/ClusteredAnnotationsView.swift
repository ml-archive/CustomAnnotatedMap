import CustomAnnotatedMap
import MapKit
import SwiftUI

private class ViewModel: ObservableObject {
    struct IdentifiablePlace: Identifiable {
        let id: UUID
        let name: String
        let coordinate: CLLocationCoordinate2D

        init(id: UUID = UUID(), name: String, lat: Double, long: Double) {
            self.id = id
            self.name = name
            self.coordinate = CLLocationCoordinate2D(
                latitude: lat,
                longitude: long
            )
        }
    }

    @Published var coordinateRegion: CoordinateRegion = .init(
        center: .init(latitude: 51.507222, longitude: -122.009_020),
        span: .init(latitudeDelta: 30, longitudeDelta: 30)
    )

    let locations = [
        IdentifiablePlace(
            name: "Apple Park",
            lat: 37.334_900,
            long: -122.009_020
        ),
        IdentifiablePlace(
            name: "London",
            lat: 51.507222,
            long: -0.1275
        ),
        IdentifiablePlace(
            name: "Paris",
            lat: 48.8567,
            long: 2.3508
        ),
        IdentifiablePlace(
            name: "Paris",
            lat: 48.8568,
            long: 2.3519
        ),
        IdentifiablePlace(
            name: "Paris",
            lat: 48.8579,
            long: 2.3620
        ),
        IdentifiablePlace(
            name: "Paris",
            lat: 48.8580,
            long: 2.3731
        ),
        IdentifiablePlace(
            name: "Paris",
            lat: 48.8591,
            long: 2.3942
        ),
        IdentifiablePlace(
            name: "Rome",
            lat: 41.9,
            long: 12.5
        ),
        IdentifiablePlace(
            name: "Washington DC",
            lat: 38.895111,
            long: -77.036667
        ),
    ]
}

struct ClusteredAnnotationsView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            CustomAnnotatedMap(
                coordinateRegion: $viewModel.coordinateRegion,
                annotationItems: viewModel.locations,
                annotationContent: { place in
                    MapAnnotation(
                        coordinate: place.coordinate,
                        clusteringIdentifier: "clusteringIdentifier",
                        content: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.red)
                                .frame(width: 33, height: 33)
                                .overlay(
                                    Circle()
                                        .fill(.purple)
                                        .overlay(Circle().stroke())
                                        .padding(8)
                                )
                        },
                        contentCluster: {
                            Circle()
                                .fill(.purple)
                                .frame(width: 66, height: 66)
                                .overlay(
                                    Circle()
                                        .stroke(lineWidth: 5)
                                        .padding(2.5)
                                )
                        }
                    )
                }
                // selected: $viewModel.selectedAnnotation
                // action: (Annotation) -> Void
                /*
                 action: { annotation in
                 ...viewModel.bla(annotation)
                 }
                 */
            )
            //.onAnnotationSelected {  annotation in
            // ...
            // }
        

            Text(
                """
                lat: \(viewModel.coordinateRegion.center.latitude)
                lon: \(viewModel.coordinateRegion.center.longitude)
                """
            )
            .font(.footnote)

        }
        .navigationTitle("Clustered Annotations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClusteredAnnotationsView_Previews: PreviewProvider {
    static var previews: some View {
        ClusteredAnnotationsView()
    }
}
