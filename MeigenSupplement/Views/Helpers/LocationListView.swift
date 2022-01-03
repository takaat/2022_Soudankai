//
//  LocationListView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/01.
//

import SwiftUI
import MapKit

struct LocationListView: View {
    @State private var requests: [UNNotificationRequest] = []
    @State private var coordinate: MKCoordinateRegion = .init()
// CLRegionからMKCoordinateRegionへ変換すること。最後は、Bindingで渡す。
    var values: [(String, MKCoordinateRegion)] {
        filterRequests(requests: requests)
    }
    var body: some View {
        List {
            Text("LocationListView")
            ForEach(values, id: \.0) { value in
                MapView(region: value.1)
                    .frame(width: /*@START_MENU_TOKEN@*/500.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/500.0/*@END_MENU_TOKEN@*/)
                
            }
        }
        .listStyle(.plain)
        .onAppear {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                self.requests = requests
            }
        }

    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
