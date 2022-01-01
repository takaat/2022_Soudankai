//
//  NotificationModel.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/30.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Environment(\.managedObjectContext) private var context
//    @Published var requests: [UNNotificationRequest] = []
    private let center = UNUserNotificationCenter.current()
//    @EnvironmentObject private var cdmodel: CDModel //コンテントビューの子孫ではないため
    let cdmodel = CDModel()

    func startup() {
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            if granted {
                print("通知許可を得た")
            }
        }
    }

    func setRequests(comletion: @escaping ([UNNotificationRequest]) -> Void) {
        center.getPendingNotificationRequests { requests in
            comletion(requests)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
        print("フォアグランドで通知発火")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let meigen = response.notification.request.content.body
        let auther = response.notification.request.content.subtitle
        cdmodel.addMotto(context: context, meigen: meigen, auther: auther)
        completionHandler()
    }
}
