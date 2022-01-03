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

    var values: [(String, MKCoordinateRegion)] {
        filterRequests(requests: requests)
    }

    var body: some View {
        List {
            Text("LocationListView")
            ForEach(values, id: \.0) { value in
                MapView(region: value.1)
                    .frame(width: 300, height: 500)
            }
            .onDelete { index in
                deleteNotification(offset: index)
            }
        }
        .listStyle(.plain)
        .onAppear {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                self.requests = requests
            }
        }
    }

    private func deleteNotification(offset: IndexSet) {
        let identifier = values[offset.first ?? 0].0
        let filterdArray = requests.filter { $0.identifier == identifier }
        let targetindex = requests.firstIndex(of: filterdArray[0])
        requests.remove(at: targetindex ?? 0)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
