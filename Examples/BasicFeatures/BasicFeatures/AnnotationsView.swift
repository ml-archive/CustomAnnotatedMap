import CustomMapView
import MapKit
import SwiftUI

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let name: String
    let location: CLLocationCoordinate2D

    init(id: UUID = UUID(), name: String, lat: Double, long: Double) {
        self.id = id
        self.name = name
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long
        )
    }
}

private class ViewModel: ObservableObject {
    private var _mapRect = MapRect(
        origin: .init(
            CLLocationCoordinate2D(
                latitude: 37.334_900,
                longitude: -122.009_020
            )
        ),
        size: .init(width: 100_000_000, height: 100_000_000)
    )
    // FIXME: coordinate values
    // {
    //     willSet { objectWillChange.send() }
    // }

    var mapRect: MapRect {
        get { self._mapRect }
        set { self._mapRect = newValue }
    }

    var mkMapRect: MKMapRect {
        get { self._mapRect.rawValue }
        set { self._mapRect = .init(rawValue: newValue) }
    }

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

struct AnnotationsView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {

            Map(
                mapRect: $viewModel.mkMapRect,
                annotationItems: viewModel.locations,
                annotationContent: {
                    MapMarker(coordinate: $0.location, tint: .purple)
                }
            )

            ClusterMap(
                mapRect: $viewModel.mapRect,
                annotationItems: viewModel.locations,
                annotationContent: {
                    ClusterMapMarker(
                        coordinate: $0.location,
                        clusteringIdentifier: "something",
                        tint: .green
                    )
                }
            )

            //FIXME: check correct binding
            Text(
                """
                \($viewModel.mapRect.wrappedValue.origin.x) - \($viewModel.mapRect.wrappedValue.origin.y)
                """
            )

        }
        .navigationTitle("User Location")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnnotationsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationsView()
    }
}
