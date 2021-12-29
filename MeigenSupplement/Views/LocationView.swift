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

    struct AnnotationItemStruct: Identifiable{
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    @StateObject var coordinator = LocationCoordinator()
    @State private var inputText = ""
    @State private var preRegion: CLLocationCoordinate2D?
    @State private var isShowAlert = false
    @State var annotationItems: [AnnotationItemStruct] = []

    var body: some View {
        VStack{
            Map(coordinateRegion: $coordinator.region,
                showsUserLocation: true,
                annotationItems: annotationItems) { item in
                MapMarker(coordinate: item.coordinate, tint: .purple)
            }
            .ignoresSafeArea(edges: .top)

            HStack {
                TextField("", text: $inputText, prompt: Text("場所を入力"))
                    .padding()
                    .onSubmit {
                        coordinator.localSearch(
                            inputRegion: coordinator.region,
                            inputText: inputText) { targetRegion in
                                preRegion = targetRegion
                                coordinator.region.center = targetRegion
                                annotationItems.append(.init(coordinate: targetRegion))
                            }
                        closeKeyboard()
                    }

                Button("登録") {
                    let region = CLCircularRegion(center: preRegion ?? .init(), radius: 1000, identifier: UUID().uuidString)
                    region.notifyOnExit = false
                    getMotto { meigen, auther in
                        setNotification(meigen: meigen, auther: auther, typeOfTrigger: .location(region))
                    }
                }

                Button(action: {
                    coordinator.requestLocation()
                    coordinator.setup(didUpdate: { userLocation in coordinator.region.center = userLocation.coordinate})
                }, label: { Label("現在地", systemImage: "location.fill").foregroundColor(.red) })
            }
        }
        .alert("登録完了", isPresented: $isShowAlert) {
            Text("場所指定で登録しました。")
        }
        .onAppear{
            coordinator.startCoodinator()
            coordinator.setup { userLocation in coordinator.region.center = userLocation.coordinate }
        }
        .onTapGesture {
            closeKeyboard()
        }
    }

    private func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
