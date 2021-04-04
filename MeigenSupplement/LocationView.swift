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
    
    func makeCoordinator() {
        locationManeger.requestWhenInUseAuthorization()
//        locationManeger.delegate = Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(setword, completionHandler: {(placemarks,error) in
            guard let location = placemarks?.first?.location else{
                return
            }
            let targetlocation = location.coordinate
            uiView.region = MKCoordinateRegion(center: targetlocation, latitudinalMeters: 500, longitudinalMeters: 500)
        })
    }

//    class Coordinator: NSObject,CLLocationManagerDelegate{
//
//        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//            return
//        }
//    }
}



