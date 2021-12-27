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
    @State private var setword = ""
    @State var isEditting = false
    @State private var isShowAlert = false
    @State private var isUserLocation: Bool = false
    
    var body: some View {
        
        ZStack{
            
            MapView(setword: $setword,isUserLocation: $isUserLocation)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.closeKeyboard()
                }
            
            VStack{
                
                VStack {
                    
                    SearchBar(setword: $setword, isEditting: $isEditting)
                    //                        .frame(width: 355)
                        .cornerRadius(20)
                        .padding([.top, .leading, .trailing])
                        .shadow(color: isEditting ? .blue : .clear, radius: 3)
                    //登録したら、登録しましたとダイアログが出るようにしたいな。
                    HStack{
                        Spacer()
                        if #available(iOS 15.0, *){
                            Button("登 録", action: {
                                //ここに通知を設定すること})
                                LocationNotification(setword: $setword).basedOnLocationNotification()
//                                setword = ""
                                isShowAlert = true
                                isEditting = false
                            })
                            
                                .disabled(setword.isEmpty)
                                .frame(width: 80, height:50 )
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                                .buttonStyle(.borderless)
                                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                                .alert("登録完了", isPresented: $isShowAlert) {
//                                    Button("了解") {
//                                        // 了解ボタンが押された時の処理
//                                    }
                                } message: {
                                    Text("場所指定で登録しました。")
                                }
                        }
                        else{
                            Button("登 録", action: {
                                //ここに通知を設定すること})
                                LocationNotification(setword: $setword).basedOnLocationNotification()
//                                setword = ""
                                isShowAlert = true
                                isEditting = false
                            })
                            
                                .disabled(setword.isEmpty)
                                .frame(width: 80, height:50 )
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                                .buttonStyle(.borderless)
                                .alert(isPresented: $isShowAlert){
                                    Alert(title: Text("登録完了"), message: Text("場所指定で登録しました。"))
                                }
                        }
                    }
                    Button("現在地", action: { isUserLocation.toggle() })
                    
                }
                Spacer()
            }
        }
    }//.navigationBarTitleDisplayMode(.inline)
}


struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}

struct MapView: UIViewRepresentable{
    
    typealias UIViewType = MKMapView
    @Binding var setword: String
    @Binding var isUserLocation: Bool
    
    
    func makeUIView(context: Context) -> MKMapView {
        CLLocationManager().requestWhenInUseAuthorization()
        let mapView = MKMapView()
        currentUserLocation(uiView: mapView)
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
                  let location = target.placemark.location else {
                      return currentUserLocation(uiView: uiView)
                  }
            let targetlocation = location.coordinate
            pin.coordinate = targetlocation
            uiView.region = MKCoordinateRegion(center: targetlocation, latitudinalMeters: 500, longitudinalMeters: 500)
            uiView.addAnnotation(pin)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, isUserLocation: $isUserLocation)
    }
    
    class Coordinator: NSObject,MKMapViewDelegate {
        
        var parent: MapView
        @Binding var isUserLocation: Bool
        
        init(_ parent: MapView,isUserLocation: Binding<Bool>) {
            self.parent = parent
            _isUserLocation = isUserLocation
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            currentUserLocation(uiView: mapView)
        }
        
        func showUserLocation() {
            let mapView = MKMapView()
            if isUserLocation {
                currentUserLocation(uiView: mapView)
                isUserLocation.toggle()
            }
        }
    }
}

protocol CurrentUserLocationDelegate:NSObjectProtocol {
    
}

func currentUserLocation<T>(uiView:T) where T: MKMapView {
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let userRegion = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
    uiView.setRegion(userRegion, animated: true)
}

struct SearchBar: UIViewRepresentable {
    
    typealias UIViewType = UISearchBar
    @Binding var setword: String
    @Binding var isEditting: Bool
    
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
            parent.isEditting = true
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let setword = searchBar.text else{
                return searchBar.text = ""
            }
            parent.setword = setword
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            parent.setword = ""
            parent.isEditting = false
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

