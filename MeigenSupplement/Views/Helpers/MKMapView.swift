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
    let map = MKMapView()
    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
        // 地図を固定。ピンを打つ　もたつくのでスクロールビューかな
        map.region = region
        return map
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        return
    }
}
