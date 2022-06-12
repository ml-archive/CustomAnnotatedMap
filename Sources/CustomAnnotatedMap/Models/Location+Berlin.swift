import Foundation

/// - [the-geographical-center-of-berlin](https://digitalcosmonaut.com/2013/the-geographical-center-of-berlin/)
/// - [Mittelpunkte_Deutschlands](https://de.wikipedia.org/wiki/Mittelpunkte_Deutschlands)
///
/// <gpx>
///    <wpt lat="52.502889" lon="13.404194"></wpt>
/// </gpx>
///
extension Location {
    public static var centerOfBerlin: Self = .init(
        latitude: 52.502889,
        longitude: 13.404194
    )
}
