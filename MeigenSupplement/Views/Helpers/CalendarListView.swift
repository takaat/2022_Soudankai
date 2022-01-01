//
//  NotificaitonRowView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/01.
//

import SwiftUI

struct CalendarListView: View {
//    @EnvironmentObject var notificationModel: NotificationModel
    @State private var requests: [UNNotificationRequest] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(requests, id: \.self) { request in
                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                       let date = trigger.dateComponents.date {
                        Text(DateFormatter().string(from: date))
                    }
                }
                Text("CalendarListView")
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                self.requests = requests
                print(self.requests)
            }
        }
        .navigationTitle("日時で登録した通知")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct CalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView()
    }
}
