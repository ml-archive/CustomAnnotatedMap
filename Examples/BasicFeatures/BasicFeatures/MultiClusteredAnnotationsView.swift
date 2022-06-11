import CustomAnnotatedMap
import MapKit
import SwiftUI

private class ViewModel: ObservableObject {
    struct IdentifiablePlace: Identifiable {
        enum PlaceType {
            case one
            case two
        }

        let id: UUID
        let name: String
        let coordinate: CLLocationCoordinate2D
        let placeType: PlaceType

        init(
            id: UUID = UUID(), name: String, lat: Double, long: Double, placeType: PlaceType = .one
        ) {
            self.id = id
            self.name = name
            self.coordinate = CLLocationCoordinate2D(
                latitude: lat,
                longitude: long
            )
            self.placeType = placeType
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
            name: "Paris 1",
            lat: 48.8567,
            long: 2.3508
        ),
        IdentifiablePlace(
            name: "Paris 2",
            lat: 48.8568,
            long: 2.3519
        ),
        IdentifiablePlace(
            name: "Paris 3",
            lat: 48.8579,
            long: 2.3620
        ),
        IdentifiablePlace(
            name: "Paris 4",
            lat: 48.8580,
            long: 2.3731,
            placeType: .two
        ),
        IdentifiablePlace(
            name: "Paris 5",
            lat: 48.8591,
            long: 2.3942,
            placeType: .two
        ),
        IdentifiablePlace(
            name: "Rome",
            lat: 41.9,
            long: 12.5,
            placeType: .two
        ),
        IdentifiablePlace(
            name: "Washington DC",
            lat: 38.895111,
            long: -77.036667
        ),
    ]
}

struct MultiClusteredAnnotationsView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            CustomAnnotatedMap(
                coordinateRegion: $viewModel.coordinateRegion,
                annotationItems: viewModel.locations,
                annotationContent: { place in
                    MapAnnotation.init(coordinate: place.coordinate, content: {})
                    //FIXME: why? an enum cant be used here ? @ViewBuilder somehow?
                    // switch place.type {
                    // case .one:
                    //     return MapAnnotation.init(coordinate: place.coordinate, content: {})
                    // case .two:
                    //     return MapAnnotation.init(coordinate: place.coordinate, content: {})
                    // }
                },
                action: { place in
                    print(">>> selected:", place.name)
                }
            )

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

struct MultiClusteredAnnotationsView_Previews: PreviewProvider {
    static var previews: some View {
        MultiClusteredAnnotationsView()
    }
}
