import Foundation
import MapKit

@dynamicMemberLookup
public struct MapRect {
    public let rawValue: MKMapRect

    public init(rawValue: MKMapRect) {
        self.rawValue = rawValue
    }

    public init(origin: MKMapPoint, size: MKMapSize) {
        self.rawValue = .init(origin: origin, size: size)
    }

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.rawValue = .init(x: x, y: y, width: width, height: height)
    }

    public init(location: Location, width: Double, height: Double) {
        self.rawValue = .init(
            origin: .init(location.coordinate),
            size: .init(width: width, height: height)
        )
    }

    public init() {
        self.rawValue = .init()
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<MKMapRect, T>) -> T {
        self.rawValue[keyPath: keyPath]
    }
}

extension MapRect {
    public var coordinateRegion: CoordinateRegion {
        get {
            CoordinateRegion.init(self.rawValue)
        }
        set {
            self = newValue.mapRect
        }
    }
}

extension MapRect: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.origin.x == rhs.origin.x
            && lhs.origin.y == rhs.origin.y
            && lhs.size.width == rhs.size.width
            && lhs.size.height == rhs.size.height
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.origin.x)
        hasher.combine(self.origin.y)
        hasher.combine(self.size.width)
        hasher.combine(self.size.height)
    }
}

extension MapRect {
    /// Compares two instances of MapRect with 0.0001 degrees precision (approx 10 metres)
    /// Precision is set due to slight inaccuracies in MKMap region property during map movements
    /// - Parameter mapRect: MapRect to compare
    /// - Returns: The differences in centers and spans of the mapRects are smaller than 10 metres
    func isSame(as mapRect: MapRect?) -> Bool {
        guard let mapRect = mapRect else {
            return false
        }
        
        return (abs(mapRect.coordinateRegion.center.latitude - self.coordinateRegion.center.latitude) < 0.0001) &&
        (abs(mapRect.coordinateRegion.center.longitude - self.coordinateRegion.center.longitude) < 0.0001) &&
        (abs(mapRect.coordinateRegion.span.latitudeDelta - self.coordinateRegion.span.latitudeDelta) < 0.0001) &&
        (abs(mapRect.coordinateRegion.span.longitudeDelta - self.coordinateRegion.span.longitudeDelta) < 0.0001)
    }
}
