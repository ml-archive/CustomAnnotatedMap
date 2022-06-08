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
