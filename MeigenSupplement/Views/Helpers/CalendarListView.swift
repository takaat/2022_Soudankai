//
//  NotificaitonRowView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/01.
//

import SwiftUI
// MARK: 日時で登録した通知を表示する画面
struct CalendarListView: View {
    @State private var requests: [UNNotificationRequest] = []

    var listData: [(String, Date)] {
        filterRequests(requests: requests)
    }

    var body: some View {
        List {
            ForEach(listData, id: \.0) { element in
                VStack(alignment: .leading, spacing: 10) {
                    Text(makeDateText(date: element.1).0)
                        .font(.title2)
                    Text(makeDateText(date: element.1).1)
                        .font(.title2)
                }
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

    private func makeDateText(date: Date) -> (String, String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        let dates = formatter.string(from: date)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: date)
        return (dates, time)
    }

    private func deleteNotification(offset: IndexSet) {
        let identifier = listData[offset.first ?? 0].0
        let filterdArray = requests.filter { $0.identifier == identifier }
        let targetindex = requests.firstIndex(of: filterdArray[0])
        requests.remove(at: targetindex ?? 0)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
 struct CalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView()
    }
 }
