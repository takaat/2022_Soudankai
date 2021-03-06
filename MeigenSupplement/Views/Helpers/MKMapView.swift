//
//  MKMapView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/03.
//

import Foundation
import SwiftUI
import MapKit
// MARK: LocationListViewのうち１行単位の地図を表示する画面
struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    private let map = MKMapView()
    typealias UIViewType = MKMapView

    func makeUIView(context: Context) -> MKMapView {
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
