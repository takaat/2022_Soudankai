//
//  GetMeigen.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import CoreLocation
import SwiftUI
import MapKit

func getMotto(completion: @escaping (String, String) -> Void) {
    struct ResultJson: Codable {
        let meigen: String?
        let auther: String?
    }

    guard let requestUrl = URL(string: "https://meigen.doodlenote.net/api/json.php?c=1") else { return }
    let request = URLRequest(url: requestUrl)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { data, _, error in session.finishTasksAndInvalidate()

        if let error = error {
            print(error)
            fatalError("エラーが出ました。エラー内容：" + error.localizedDescription)
        }

        do {
            guard let data = data else { return }
            let results = try JSONDecoder().decode([ResultJson].self, from: data)
            completion(results[0].meigen ?? "", results[0].auther ?? "")
        } catch {
            print(error)
            fatalError("エラーが出ました。エラー内容：" + error.localizedDescription)
        }
    }

    task.resume()
}

enum TypeOfTrigger {
    case calendar(DateComponents)
    case location(CLRegion)

    var trigger: UNNotificationTrigger {
        switch self {
        case .calendar(let date):
            return UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        case .location(let region):
            return UNLocationNotificationTrigger(region: region, repeats: false)
        }
    }
}

func setNotification(meigen: String, auther: String, typeOfTrigger: TypeOfTrigger) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.subtitle = auther
    content.body = meigen
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: typeOfTrigger.trigger)
    center.add(request) { error in
        if let error = error {
            fatalError(error.localizedDescription)
        }
    }
}

func filterRequests(requests: [UNNotificationRequest]) -> [(identifier: String, date: Date)] {
    var tempArray: [(String, Date)] = []
    var tempTuple = ("", Date())

    for request in requests {
        tempTuple.0 = request.identifier

        if let trigger = request.trigger,
           trigger is UNCalendarNotificationTrigger,
           let trigger = trigger as? UNCalendarNotificationTrigger {
            var dateComponents = trigger.dateComponents
            dateComponents.calendar = .current
            tempTuple.1 = dateComponents.date ?? Date()
            tempArray.append(tempTuple)
        }
    }
    return tempArray
}

func filterRequests(requests: [UNNotificationRequest]) -> [(identifier: String, data: MKCoordinateRegion)] {
    var tempArray: [(String, MKCoordinateRegion)] = []
    var tempTuple = ("", MKCoordinateRegion())

    for request in requests {
        tempTuple.0 = request.identifier

        if let trigger = request.trigger,
           trigger is UNLocationNotificationTrigger,
           let trigger = trigger as? UNLocationNotificationTrigger {
            let region = trigger.region as? CLCircularRegion
            let mkRegion = MKCoordinateRegion(center: region?.center ?? .init(),
                                           span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            tempTuple.1 = mkRegion
            tempArray.append(tempTuple)
        }
    }
    return tempArray
}
