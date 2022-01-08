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
    private let context = PersistenceController.shared.container.viewContext
    // @Environmentは親ビューから子ビューに伝播するものなのでクラスには伝播しない。よってクラス内に新たにcontextを宣言する必要がある。
    private let coreDataModel = CoreDataModel()
    private let center = UNUserNotificationCenter.current()

    func startup() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("通知許可を得た")
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        let meigen = notification.request.content.body
        let auther = notification.request.content.subtitle
        coreDataModel.addMotto(context: context, meigen: meigen, auther: auther)
        completionHandler([.banner, .sound, .list])
        print("フォアグランドで通知発火")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action":
            let meigen = response.notification.request.content.body
            let auther = response.notification.request.content.subtitle
            coreDataModel.addMotto(context: context, meigen: meigen, auther: auther)
            print("didReciveのactionを実行した")
        default:
            break
        }
        completionHandler()
        print("バックグランドで通知発火")
    }
}
