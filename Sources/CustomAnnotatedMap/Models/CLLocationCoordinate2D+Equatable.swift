import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
