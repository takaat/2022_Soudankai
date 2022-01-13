//
//  GetMeigen.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import CoreLocation
import MapKit

// MARK: - オーバーロードあり(1/2)
func filterRequests(requests: [UNNotificationRequest]) -> [(String, Date)] {
    var tempArray: [(String, Date)] = []
//    var tempTuple = ("", Date())

    for request in requests {
//        tempTuple.0 = request.identifier

        if let trigger = request.trigger,
           trigger is UNCalendarNotificationTrigger,
           let trigger = trigger as? UNCalendarNotificationTrigger {
            var dateComponents = trigger.dateComponents
            dateComponents.calendar = .current
//            tempTuple.1 = dateComponents.date ?? Date()
            tempArray.append((identifier:request.identifier, date:dateComponents.date ?? Date()))
        }
    }
    return tempArray
}
// MARK: - オーバーロードあり (2/2)
func filterRequests(requests: [UNNotificationRequest]) -> [(String, MKCoordinateRegion)] {
    var tempArray: [(String, MKCoordinateRegion)] = []
//    var tempTuple = ("", MKCoordinateRegion())

    for request in requests {
//        tempTuple.0 = request.identifier

        if let trigger = request.trigger,
           trigger is UNLocationNotificationTrigger,
           let trigger = trigger as? UNLocationNotificationTrigger {
            let region = trigger.region as? CLCircularRegion
            let mkRegion = MKCoordinateRegion(center: region?.center ?? .init(),
                                           span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
//            tempTuple.1 = mkRegion
            tempArray.append((identifier: request.identifier, region: mkRegion))
        }
    }
    return tempArray
}
// MARK: - これを使うと再描画されてしまうので不使用
func deleteNotification<U>(offset: IndexSet, requests: [UNNotificationRequest], lists: [(String, U)]) {
    var requests = requests
    let identifier = lists[offset.first ?? 0].0 // 削除対象のidentifierを取り出す
    let filterdArray = requests.filter { $0.identifier == identifier } // requestsの配列からidentifierが一致する要素を探す
    let targetindex = requests.firstIndex(of: filterdArray[0]) // indexを取り出して削除する。
    requests.remove(at: targetindex ?? 0)
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
}
