import Foundation
import MapKit

public enum UserTrackingMode: Int, Equatable {
    /// the user's location is not followed
    case none = 0

    /// the map follows the user's location
    case follow = 1

    /// the map follows the user's location and heading
    case followWithHeading = 2
}

extension UserTrackingMode {
    init?(_ trackingMode: MKUserTrackingMode) {
        switch trackingMode {
        case .none:
            self = .none
        case .follow:
            self = .follow
        case .followWithHeading:
            self = .followWithHeading
        @unknown default:
            return nil
        }
    }
}
