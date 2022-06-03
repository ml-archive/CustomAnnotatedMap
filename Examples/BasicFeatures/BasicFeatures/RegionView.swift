import CustomMapView
import MapKit
import SwiftUI

private class ViewModel: ObservableObject {
    private var _region = CoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.334_900,
            longitude: -122.009_020
        ),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )
    // FIXME: coordinate values
    // {
    //     willSet { objectWillChange.send() }
    // }

    var region: CoordinateRegion {
        get { self._region }
        set { self._region = newValue }
    }

    var mkRegion: MKCoordinateRegion {
        get { self._region.rawValue }
        set { self._region = .init(rawValue: newValue) }
    }
}

struct RegionView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.mkRegion)
            CustomMapView(coordinateRegion: $viewModel.region)
        }
        .navigationTitle("Region")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegionView_Previews: PreviewProvider {
    static var previews: some View {
        RegionView()
    }
}
