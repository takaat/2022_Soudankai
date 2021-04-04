//
//  TimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import SwiftUI

struct TimeNotification {     //通知に名言を載せるなら、クラスにしてNSOBJECTに準拠する必要がある。
    
   // @ObservedObject var meigen = Meigen()
    @Binding var date: Date
   
    
    init(date: Binding<Date>) {
        self._date = date
    }
    
    func basedOnTimeNotification(){//関数の中でインスタンス化しないとエラーになる。
        // ローカル通知のの内容
        //meigen.getMeigen()
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
//        center.delegate = AppDelegate()
        content.sound = UNNotificationSound.default
        content.title = "本日の名言が配信されました。"
        content.subtitle = "日時に基づく通知です。"
        content.body = "今日から明日へ"
        content.categoryIdentifier = "action"
        let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
        let categories = UNNotificationCategory(identifier: "action", actions: [open,cancel], intentIdentifiers: [])
        center.setNotificationCategories([categories])
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        // ローカル通知リクエストを作成
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // ユニークなIDを作る
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        
        center.add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


