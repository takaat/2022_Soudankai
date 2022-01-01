//
//  NotificationListView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/01.
//

import SwiftUI

struct NotificationListView: View {
    private let types = ["日時", "場所"]
    @State private var selection = "日時"

    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(types, id: \.self) { type in
                    Text(type)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if selection == "日時" {
                CalendarListView()
            } else {
                LocationListView()
            }

            Spacer()
        }
    }
}

struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}
