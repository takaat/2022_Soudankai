//
//  Location.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/29.
//

import Foundation
import CoreLocation
import MapKit

class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region: MKCoordinateRegion = .init(center: .init(),
                                                      span: .init(latitudeDelta: 0.003, longitudeDelta: 0.003))
    @Published var isRegisterButton = true
    @Published var isFailureAlert = false
    @Published var isShowRegisterdAlert = false
    @Published var inputText = ""
    @Published var centerRegion: CLLocationCoordinate2D = .init()
    @Published var annotationItems: [AnnotationItemStruct] = []
    private let locationManager = CLLocationManager()
    private var didUpdate: (CLLocation) -> Void = { _ in }

    struct AnnotationItemStruct: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    func startup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func setup(didUpdate: @escaping (CLLocation) -> Void) {
        self.didUpdate = didUpdate
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
// MARK: キーワードから場所を検索する
    func localSearch(inputRegion: MKCoordinateRegion,
                     inputText: String,
                     completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = inputText
        searchRequest.region = inputRegion
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: {response, _ in
            guard let targetRegion = response?.mapItems.first?.placemark.coordinate else {
                self.isFailureAlert = true
                return print("検索失敗！") }
            self.isRegisterButton = false
            completion(targetRegion)
        })
    }

    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("マネジャー始動")
        didUpdate(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ロケーションマネジャーにてエラー発生:\(error.localizedDescription)")
    }
}
