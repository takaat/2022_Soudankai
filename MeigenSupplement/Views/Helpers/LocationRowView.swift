//
//  LocationRowView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/03.
//

import SwiftUI
import MapKit

struct LocationRowView: View {
    @Binding  var coordinate: MKCoordinateRegion

    var body: some View {
        Map(coordinateRegion: $coordinate)
    }
}

struct LocationRowView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRowView(coordinate: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )))
    }
}
