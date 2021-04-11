//
//  LocationNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import SwiftUI
import CoreLocation


struct LocationNotification {
    
    @Binding var setword: String
    @Binding var repeatLocation: Bool
//    let locationManager = CLLocationManager()
    
    init(setword: Binding<String>,repeatLocation: Binding<Bool>) {
        self._setword = setword
        self._repeatLocation = repeatLocation
    }
    func basedOnLocationNotification(){
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(setword, completionHandler: {(placemarks,error) in
            
            guard let region = placemarks?.first?.region else{
                return print("位置情報が取得できません")
            }
            region.notifyOnExit = false
            
//            locationManager.delegate = self
//            func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//                return
//            }
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default
            content.title = "本日の名言が配信されました。"
            content.subtitle = "位置情報に基づく通知です。"
            content.body = "今日から明日へ"
            content.categoryIdentifier = "action"
            let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
            let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
            let categories = UNNotificationCategory(identifier: "action", actions: [open,cancel], intentIdentifiers: [])
            center.setNotificationCategories([categories])
            // ローカル通知リクエストを作成
            let trigger = UNLocationNotificationTrigger(region: region, repeats: repeatLocation)
            // ユニークなIDを作る
            let identifier = UUID().description
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            // ローカル通知リクエストを登録
            center.add(request){ (error : Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        })
    }
}
