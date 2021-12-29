//
//  TimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import SwiftUI

class TimeNotification {     //通知に名言を載せるなら、クラスにしてNSOBJECTに準拠する必要がある。

    let meigen = Meigen() //letでも良いかも
    @Binding var date: Date

    
    init(date: Binding<Date>) {
        self._date = date
    }

    func basedOnTimeNotification(){//関数の中でインスタンス化しないとエラーになる。
        meigen.getMeigen(callback: sendTimeNotification)
    }

    func sendTimeNotification(){
        // ローカル通知の内容
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        var notification = Notification()
        let userDefaultOperationNotification = UserDefaultOperationNotification()
        var notifications = [Notification]()
//        center.delegate = AppDelegate()
        content.sound = UNNotificationSound.default
//        content.title = "本日の名言が配信されました。"
        content.subtitle = meigen.auther
        content.body = meigen.meigen
        content.categoryIdentifier = "action"
        let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let addmyfavorite = UNNotificationAction(identifier: "addmyfavorite", title: "お気に入りに登録", options: [])
        let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
        let categories = UNNotificationCategory(identifier: "action", actions: [open,addmyfavorite,cancel], intentIdentifiers: [])
        center.setNotificationCategories([categories])

        let component = Calendar.current.dateComponents([.year, .month, .day, .weekday,.hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // ユニークなIDを作る
        let identifier = "T" + UUID().description
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // ローカル通知リクエストを登録
        center.add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //構造体に追加し、その構造体を配列に保存。その配列をuserdefaaultに保存の処理を書くか。
                notifications = userDefaultOperationNotification.loadUserDefault()
                notification.id = identifier
                notification.date = self.date
                notifications.append(notification)
                userDefaultOperationNotification.saveUserDefault(array: notifications)
            }
        }
    }
}


