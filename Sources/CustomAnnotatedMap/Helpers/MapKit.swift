//
//  File.swift
//  
//
//  Created by Jiří Buček on 28.07.2022.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    func equals(to other: MKCoordinateRegion) -> Bool {
        center.equals(to: other.center)
        && span.equals(to: other.span)
    }
}

extension CLLocationCoordinate2D {
    func equals(to other: CLLocationCoordinate2D) -> Bool {
        latitude == other.latitude
        && longitude == other.longitude
    }
}

