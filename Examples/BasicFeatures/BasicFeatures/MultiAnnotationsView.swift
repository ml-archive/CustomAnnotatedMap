import CustomAnnotatedMap
import SwiftUI

private class ViewModel: ObservableObject {
    struct IdentifiablePlace: Identifiable {
        enum PlaceType {
            case one
            case two
        }

        let id: UUID
        let name: String
        let location: Location
        let placeType: PlaceType

        init(
            id: UUID = UUID(),
            name: String,
            lat: Double,
            long: Double,
            placeType: PlaceType = .one
        ) {
            self.id = id
            self.name = name
            self.location = Location(
                latitude: lat,
                longitude: long
            )
            self.placeType = placeType
        }
    }

    @Published var coordinateRegion: CoordinateRegion = .init(
        location: .centerOfBerlin,
        latitudeDelta: 30,
        longitudeDelta: 30
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

struct MultiAnnotationsView: View {
    @StateObject private var viewModel: ViewModel = .init()

    /// Swift <= 5.6 Requires explicit type erasure (wrapping `AnyView`) to avoid "Function declares an opaque return type, but the return statements in its body do not have matching underlying types"
    fileprivate func annotationForLocation(_ place: ViewModel.IdentifiablePlace)
        -> some MapAnnotationProtocol
    {
        switch place.placeType {
        case .one:
            return MapAnnotation(
                location: place.location,
                content: {
                    AnyView(
                        Circle()
                            .fill(.red)
                            .frame(width: 33, height: 33)
                    )
                }
            )

        case .two:
            return MapAnnotation(
                location: place.location,
                content: {
                    AnyView(
                        Rectangle()
                            .fill(.purple)
                            .frame(width: 33, height: 33)
                    )
                }
            )
        }
    }

    var body: some View {
        VStack {
            CustomAnnotatedMap(
                coordinateRegion: $viewModel.coordinateRegion,
                annotationItems: viewModel.locations,
                annotationContent: annotationForLocation,
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

struct MultiAnnotationsViewView_Previews: PreviewProvider {
    static var previews: some View {
        MultiAnnotationsView()
    }
}
