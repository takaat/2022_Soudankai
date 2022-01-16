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

// MARK: - オーバーロードあり(1/2)　登録された通知から日時で登録されたものを選定する
func filterRequests(requests: [UNNotificationRequest]) -> [(String, Date)] {
    var tempArray: [(String, Date)] = []

    for request in requests {
        if let trigger = request.trigger,
           trigger is UNCalendarNotificationTrigger,
           let trigger = trigger as? UNCalendarNotificationTrigger {
            var dateComponents = trigger.dateComponents
            dateComponents.calendar = .current
            tempArray.append((identifier:request.identifier, date:dateComponents.date ?? Date()))
        }
    }
    return tempArray
}
// MARK: - オーバーロードあり (2/2)　登録された通知から場所で登録されたものを選定する
func filterRequests(requests: [UNNotificationRequest]) -> [(String, MKCoordinateRegion)] {
    var tempArray: [(String, MKCoordinateRegion)] = []

    for request in requests {
        if let trigger = request.trigger,
           trigger is UNLocationNotificationTrigger,
           let trigger = trigger as? UNLocationNotificationTrigger {
            let region = trigger.region as? CLCircularRegion
            let mkRegion = MKCoordinateRegion(center: region?.center ?? .init(),
                                           span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            tempArray.append((identifier: request.identifier, region: mkRegion))
        }
    }
    return tempArray
}
