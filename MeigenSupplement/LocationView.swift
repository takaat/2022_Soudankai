//
//  LocationView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationView: View {
    
    @State var inputword = ""
    @State var setword = ""
    
    var body: some View {
        VStack{
            TextField("場所を入力してください。", text: $inputword,onCommit: {setword = inputword})
                .fixedSize()
                .padding()
            //ここにマップビューを入れること
            MapView(setword: $setword)
                .padding()
                .onLongPressGesture(perform: <#T##() -> Void#>)//ここにコードを入れる。
            Button("位置情報による発火準備", action: {
                //ここに通知を設定すること})
                LocationNotification(setword: $setword).basedOnLocationNotification()
            })
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

struct MapView: UIViewRepresentable{
    
    @Binding var setword: String
    var locationManeger = CLLocationManager()
    
//    class Coordinator: NSObject,MKMapViewDelegate {
//
//        let parent: MapView
//
//        init(_ parent: MapView){
//            self.parent = parent
//        }
//
//        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//
//        }
//
//        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
//
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeCoordinator() {
//        //もしかしたらここにlocationManeger.requestWhenInUseAuthorization()を入れるかも。
//    }
    
    func makeUIView(context: Context) -> MKMapView {
        locationManeger.requestWhenInUseAuthorization()
        let mapView = MKMapView()
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        // ここで照準を合わせている
        mapView.region = region
//        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
//        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let geocoder = CLGeocoder()
        let pin = MKPointAnnotation()
        geocoder.geocodeAddressString(setword, completionHandler: {(placemarks,error) in
            guard let location = placemarks?.first?.location else{
                return
            }
            let targetlocation = location.coordinate
            pin.coordinate = targetlocation
            uiView.region = MKCoordinateRegion(center: targetlocation, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.addAnnotation(pin)
        })
    }

//    class Coordinator: NSObject,CLLocationManagerDelegate{
//
//        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//            return
//        }
//    }
}



