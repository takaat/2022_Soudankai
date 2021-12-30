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
    private let center = UNUserNotificationCenter.current()
    @EnvironmentObject var historyModel: HistoryModel

    func startup() {
        // あとでhttps://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notificationsを読んで実装する
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound,.badge]) { granted, error in
            if granted {
                print("通知許可を得た")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
        print("フォアグランドで通知発火")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let meigen = response.notification.request.content.body
        let auther = response.notification.request.content.subtitle
        historyModel.mottos.append(Motto(meigen: meigen, auther: auther))
        completionHandler()
    }
}
