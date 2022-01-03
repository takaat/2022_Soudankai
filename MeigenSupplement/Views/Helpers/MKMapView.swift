//
//  MKMapView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/03.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    private let map = MKMapView()
    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
        // 地図を固定。ピンを打つ　もたつくのでスクロールビューかな
        let pin = MKPointAnnotation()
        pin.coordinate = region.center
        map.region = region
        map.addAnnotation(pin)
        map.isScrollEnabled = false
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        return
    }
}
