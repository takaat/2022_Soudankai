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
    @Binding var repeatTime: Int
   
    
    init(date: Binding<Date>,repeatTime: Binding<Int>) {
        self._date = date
        self._repeatTime = repeatTime
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
        
        //repeatTimeの値によってcomponentとtrigerを分ける。
        var component = DateComponents()
        var repeats: Bool = false
        
        switch repeatTime {
        case 0: //繰り返しなし
            component = Calendar.current.dateComponents([.year, .month, .day, .weekday,.hour, .minute], from: date)
            repeats = false
        case 1: //毎日
            component = Calendar.current.dateComponents([.hour, .minute], from: date)
            repeats = true
        case 2: //毎週
            component = Calendar.current.dateComponents([.weekday,.hour, .minute], from: date)
            repeats = true
        default:
            break
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: repeats)
        // ユニークなIDを作る
        let identifier = UUID().description
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // ローカル通知リクエストを登録
        center.add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


