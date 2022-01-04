//
//  NotificaitonRowView.swift
//  MeigenSupplement
//
//  Created by mana on 2022/01/01.
//

import SwiftUI

struct CalendarListView: View {
    @State private var requests: [UNNotificationRequest] = []

    var values: [(String, Date)] {
        filterRequests(requests: requests) // 日付順に並び替えできないか試す。
    }

    var body: some View {
        List {
            ForEach(values, id: \.0) { value in
                VStack(alignment: .leading, spacing: 10) {
                    Text(makeDateText(date: value.1).0)
                        .font(.title2)
                    Text(makeDateText(date: value.1).1)
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
        var temp = ("", "")
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        temp.0 = formatter.string(from: date)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        temp.1 = formatter.string(from: date)
        return temp
    }

    private func deleteNotification(offset: IndexSet) {
        let identifier = values[offset.first ?? 0].0 // 削除対象のidentifierを取り出す
        let filterdArray = requests.filter { $0.identifier == identifier } // requestsの配列からidentifierが一致する要素を探す
        let targetindex = requests.firstIndex(of: filterdArray[0]) // indexを取り出して削除する。
        requests.remove(at: targetindex ?? 0)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
 struct CalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView()
    }
 }
