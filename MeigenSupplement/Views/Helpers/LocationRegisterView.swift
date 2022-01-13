//
//  LocationRegisterView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/13.
//

import SwiftUI
import CoreLocation

struct LocationRegisterView: View {
    @ObservedObject var locationModel: LocationModel

    var body: some View {
        HStack {
            TextField("", text: $locationModel.inputText, prompt: Text("場所を入力"))
                .padding()
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    locationModel.localSearch(
                        inputRegion: locationModel.region,
                        inputText: locationModel.inputText) { targetRegion in
                            locationModel.centerRegion = targetRegion
                            locationModel.region.center = targetRegion
                            locationModel.annotationItems.append(.init(coordinate: targetRegion))
                        }
                    print("inputTextの値は、\(locationModel.inputText)です")
                    locationModel.closeKeyboard()
                }

            Button("登録") {
                let region = CLCircularRegion(center: locationModel.centerRegion,
                                              radius: 1000,
                                              identifier: UUID().uuidString)
                region.notifyOnExit = false
                getMotto { meigen, auther in
                    setNotification(meigen: meigen,
                                    auther: auther,
                                    typeOfTrigger: .location(region))}
                locationModel.isShowRegisterdAlert = true
                locationModel.isRegisterButton = true
            }
            .disabled(locationModel.isRegisterButton)
            // MARK: 元に戻す処理考える -
            Button(action: {
                locationModel.requestLocation()
                locationModel.setup(didUpdate: { userLocation in
                    locationModel.region.center = userLocation.coordinate})
            }, label: { Label("現在地", systemImage: "location.fill").foregroundColor(.red).labelStyle(.iconOnly) })
        }
    }
}

struct LocationRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRegisterView(locationModel: LocationModel())
    }
}
