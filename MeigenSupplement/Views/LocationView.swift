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
    struct AnnotationItemStruct: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    @StateObject var locationModel = LocationModel()
    @State private var inputText = ""
    @State private var preRegion: CLLocationCoordinate2D?
    @State private var isShowAlert = false
    @State var annotationItems: [AnnotationItemStruct] = []

    var body: some View {
        VStack {
            Map(coordinateRegion: $locationModel.region,
                showsUserLocation: true,
                annotationItems: annotationItems) { item in
                MapMarker(coordinate: item.coordinate, tint: .purple)
            }
            .ignoresSafeArea(edges: .top)

            HStack {
                TextField("", text: $inputText, prompt: Text("場所を入力"))
                    .padding()
                    .onSubmit {
                        locationModel.localSearch(
                            inputRegion: locationModel.region,
                            inputText: inputText) { targetRegion in
                                preRegion = targetRegion
                                locationModel.region.center = targetRegion
                                annotationItems.append(.init(coordinate: targetRegion))
                            }
                        print("inputTextの値は、\(inputText)です")
                        closeKeyboard()
                    }

                Button("登録") {
                    let region = CLCircularRegion(center: preRegion ?? .init(),
                                                  radius: 1000,
                                                  identifier: UUID().uuidString)
                    region.notifyOnExit = false
                    getMotto { meigen, auther in
                        setNotification(meigen: meigen,
                                        auther: auther,
                                        typeOfTrigger: .location(region))}
                    isShowAlert = true
                    locationModel.isRegister = true
                }
                .disabled(locationModel.isRegister)  // 元に戻す処理考える

                Button(action: {
                    locationModel.requestLocation()
                    locationModel.setup(didUpdate: { userLocation in
                        locationModel.region.center = userLocation.coordinate})
                }, label: { Label("現在地", systemImage: "location.fill").foregroundColor(.red).labelStyle(.iconOnly) })
            }
        }
        .alert("登録完了",
               isPresented: $isShowAlert,
               actions: {},
               message: {Text("場所指定で登録しました。")})
        .alert("検索に失敗しました",
               isPresented: $locationModel.isFailureAlert,
               actions: {},
               message: { Text("別のキーワードで検索してください。") })
        .onAppear {
            locationModel.startup()
            locationModel.requestLocation()
            locationModel.setup { userLocation in locationModel.region.center = userLocation.coordinate }
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
