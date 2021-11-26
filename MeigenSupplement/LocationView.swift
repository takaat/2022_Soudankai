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
    @State var editting = false
    @State var repeatLocation = false
    
    var body: some View {
        
        ZStack{
            
            MapView(setword: $setword)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
            
            VStack{
                
                //                HStack(alignment: .bottom){
                //
                //                    TextField("場所または住所を検索します。", text: $inputword,
                //                              onEditingChanged: { begin in
                //                        /// 入力開始処理
                //                        if begin {
                //                            self.editting = true    // 編集フラグをオン
                //                            /// 入力終了処理
                //                        } else {
                //                            self.editting = false   // 編集フラグをオフ
                //                        }
                //                    },onCommit: {setword = inputword})
                //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                //                        .padding()
                VStack {
                    SearchBar(setword: $setword, editting: $editting)
                        .frame(width: 355)
                        .cornerRadius(8)
                        .padding([.top, .leading, .trailing])
                        .shadow(color: editting ? .blue : .clear, radius: 3)
                    
                    
                    //                    .background(Color(.systemBackground))
                    //                    .cornerRadius(8)
                    Group {
                        HStack{
                            Button("登録", action: {
                                //ここに通知を設定すること})
                                LocationNotification(setword: $setword,repeatLocation: $repeatLocation).basedOnLocationNotification()
                            })
                                .disabled(setword.isEmpty)
                            //                            .frame(width: 60, height: 36)
                            //                            .cornerRadius(8)
                                .padding(.leading, 25.0)
                            Spacer()
                            
                            
                            Image(systemName: "repeat")
                            Text("繰り返し")
                            Toggle("繰り返し", isOn: $repeatLocation)
                                .labelsHidden()
                                .padding(.trailing)
                            
                        }
                    }
                    .frame(width: 355, height:50 )
                    //                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    
                }
                
                Spacer()
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

struct MapView: UIViewRepresentable{
    
    typealias UIViewType = MKMapView
    @Binding var setword: String
    var locationManeger = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        locationManeger.requestWhenInUseAuthorization()
        let mapView = MKMapView()
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let pin = MKPointAnnotation()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = setword
        let search = MKLocalSearch(request: searchRequest)
        search.start{(response,error) in
            guard let target = response?.mapItems.first,
                  let location = target.placemark.location else{
                      let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                      let region = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
                      return uiView.setRegion(region, animated: true)
                  }
            let targetlocation = location.coordinate
            pin.coordinate = targetlocation
            uiView.region = MKCoordinateRegion(center: targetlocation, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.addAnnotation(pin)
        }
        
//        func pressMap(_ sender: UILongPressGestureRecognizer) {
//
//            let location:CGPoint = sender.location(in: uiView)
//            if (sender.state == UIGestureRecognizer.State.ended){
//                //タップした位置を緯度、経度の座標に変換する。
//                let mapPoint:CLLocationCoordinate2D = uiView.convert(location,toCoordinateFrom: uiView)
//                //ピンを作成してマップビューに登録する。
//                pin.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
//                uiView.addAnnotation(pin)
//            }
//        }
    }
    
    
    //    func updateUIView(_ uiView: MKMapView, context: Context) {
    //        let geocoder = CLGeocoder()
    //        let pin = MKPointAnnotation()
    //        geocoder.geocodeAddressString(setword, completionHandler: {(placemarks,error) in
    //            guard let location = placemarks?.first?.location else{
    //                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    //                let region = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
    //                return uiView.setRegion(region, animated: true)
    //            }
    //            let targetlocation = location.coordinate
    //            pin.coordinate = targetlocation
    //            uiView.region = MKCoordinateRegion(center: targetlocation, latitudinalMeters: 500, longitudinalMeters: 500)
    //            uiView.addAnnotation(pin)
    //        })
    //    }
}

struct SearchBar: UIViewRepresentable {
    
    typealias UIViewType = UISearchBar
    @Binding var setword: String
    @Binding var editting: Bool
    
    func makeUIView(context: Context) -> UISearchBar {
        
        let searchbar = UISearchBar()
        searchbar.placeholder = "場所または住所を検索します。"
        searchbar.searchBarStyle = .prominent
        searchbar.tintColor = .systemBackground
        searchbar.delegate = context.coordinator
        return searchbar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        return
    }
    
    func makeCoordinator() ->  SearchBar.Coordinator {
        SearchBar.Coordinator(self)
    }
    
    class Coordinator: NSObject,UISearchBarDelegate{
        
        var parent: SearchBar
        
        init(_ parent: SearchBar){
            self.parent = parent
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.editting = true
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let setword = searchBar.text else{
                return searchBar.text = ""
            }
            parent.setword = setword
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            parent.setword = ""
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

