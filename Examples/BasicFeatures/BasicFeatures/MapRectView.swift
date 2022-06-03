import CustomMapView
import MapKit
import SwiftUI

private class ViewModel: ObservableObject {
    private var _mapRect = MapRect(
        origin: .init(
            CLLocationCoordinate2D(
                latitude: 37.334_900,
                longitude: -122.009_020
            )
        ),
        size: .init(width: 4000, height: 4000)
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
}

struct MapRectView: View {
    @StateObject private var viewModel: ViewModel = .init()

    var body: some View {
        VStack {
            Map(mapRect: $viewModel.mkMapRect)
            CustomMapView(mapRect: $viewModel.mapRect)
        }
        .navigationTitle("MapRect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapRectView_Previews: PreviewProvider {
    static var previews: some View {
        MapRectView()
    }
}
