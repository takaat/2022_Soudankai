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
    @StateObject private var locationModel = LocationModel()

    var body: some View {
        VStack {
            Map(coordinateRegion: $locationModel.region,
                showsUserLocation: true,
                annotationItems: locationModel.annotationItems) { item in
                MapMarker(coordinate: item.coordinate, tint: .purple)
            }
                .ignoresSafeArea(edges: .top)
                .onTapGesture {
                    locationModel.closeKeyboard()
                }
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        locationModel.requestLocation()
                        locationModel.setup(didUpdate: { userLocation in
                            locationModel.region.center = userLocation.coordinate})
                    }, label: { Label("現在地", systemImage: "location.fill")
                            .foregroundColor(.red)
                            .labelStyle(.iconOnly)
                            .imageScale(.medium)
                    })
                        .buttonStyle(.bordered)
                        .offset(y: -30)
                        .padding(.horizontal)
                }

            LocationRegisterView(locationModel: locationModel)
                .shadow(radius: 2)
                .padding(.horizontal)
        }
        .alert("登録完了",
               isPresented: $locationModel.isShowRegisterdAlert,
               actions: {},
               message: {Text("場所指定で登録しました。")})
        .alert("\(locationModel.inputText)は、見つかりませんでした。",
               isPresented: $locationModel.isFailureAlert,
               actions: {},
               message: { Text("別のキーワードで検索してください。") })
        .onAppear {
            locationModel.startup()
            locationModel.requestLocation()
            locationModel.setup { userLocation in locationModel.region.center = userLocation.coordinate }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
