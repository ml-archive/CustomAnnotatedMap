import Foundation
import MapKit

@dynamicMemberLookup
public struct CoordinateRegion {
    public let rawValue: MKCoordinateRegion

    public init(rawValue: MKCoordinateRegion) {
        self.rawValue = rawValue
    }

    public init(
        center: CLLocationCoordinate2D,
        latitudinalMeters: CLLocationDistance,
        longitudinalMeters: CLLocationDistance
    ) {
        self.rawValue = .init(
            center: center,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
    }

    public init(_ mapRect: MKMapRect) {
        self.rawValue = .init(mapRect)
    }

    public init(center: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        self.rawValue = .init(center: center, span: span)
    }

    public init(location: Location, latitudeDelta: Double, longitudeDelta: Double) {
        self.rawValue = .init(
            center: location.coordinate,
            span: .init(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
        )
    }

    public init() {
        self.rawValue = .init()
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<MKCoordinateRegion, T>) -> T {
        self.rawValue[keyPath: keyPath]
    }
}

extension CoordinateRegion {
    public var mapRect: MapRect {
        get {
            let topLeft = CLLocationCoordinate2D(
                latitude: self.center.latitude + (self.span.latitudeDelta / 2),
                longitude: self.center.longitude - (self.span.longitudeDelta / 2))

            let bottomRight = CLLocationCoordinate2D(
                latitude: self.center.latitude - (self.span.latitudeDelta / 2),
                longitude: self.center.longitude + (self.span.longitudeDelta / 2))

            let a = MKMapPoint(topLeft)
            let b = MKMapPoint(bottomRight)

            return .init(
                rawValue: MKMapRect(
                    origin: MKMapPoint(
                        x: min(a.x, b.x),
                        y: min(a.y, b.y)
                    ),
                    size: MKMapSize(
                        width: abs(a.x - b.x),
                        height: abs(a.y - b.y)
                    )
                )
            )
        }
        set {
            self = newValue.coordinateRegion
        }
    }
}

extension CoordinateRegion: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.center.latitude == rhs.center.latitude
            && lhs.center.longitude == rhs.center.longitude
            && lhs.span.latitudeDelta == rhs.span.latitudeDelta
            && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude
            && lhs.center.longitude == rhs.center.longitude
            && lhs.span.latitudeDelta == rhs.span.latitudeDelta
            && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
