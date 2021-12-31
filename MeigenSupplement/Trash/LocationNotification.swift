////
////  LocationNotification.swift
////  MeigenSupplement
////
////  Created by 上田学 on 2021/04/04.
////
//
//import Foundation
//import UserNotifications
//import SwiftUI
//import CoreLocation
//import MapKit
//
//
//class LocationNotification {
//
//    @Binding var setword: String
////    let meigen = Meigen()
//    //    let locationManager = CLLocationManager()
//
//    init(setword: Binding<String>) {
//        self._setword = setword
//    }
//    func basedOnLocationNotification(){
//        meigen.getMeigen(callback: sendLocationNotification)
//    }
//    //        locationManager.requestWhenInUseAuthorization()
//    //        locationManager.delegate = self
//    func sendLocationNotification(){
//
//        let searchRequest = MKLocalSearch.Request()
//        searchRequest.naturalLanguageQuery = setword
//        let search = MKLocalSearch(request: searchRequest)
//
//        search.start{(response,error) in
//
//            guard let target = response?.mapItems.first,
//                  let region = target.placemark.region else{ return print("位置情報が取得できません")}
//            //        let geocoder = CLGeocoder()
//
//            //        geocoder.geocodeAddressString(setword, completionHandler: {(placemarks,error) in
//
//            //            guard let region = placemarks?.first?.region else{ return print("位置情報が取得できません") }
//            region.notifyOnExit = false
//
//            //            locationManager.delegate = self
//            //            func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//            //                return
//            //            }
//            var notification = Notification()
//            let userDefaultOperationNotification = UserDefaultOperationNotification()
//            var notifications = [Notification]()
//            let center = UNUserNotificationCenter.current()
//            let content = UNMutableNotificationContent()
//            content.sound = UNNotificationSound.default
//            //            content.title = "本日の名言が配信されました。"
//            content.subtitle = self.meigen.auther
//            content.body = self.meigen.meigen
//            content.categoryIdentifier = "action"
//            let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
//            let addmyfavorite = UNNotificationAction(identifier: "addmyfavorite", title: "お気に入りに登録", options: .foreground)
//            let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
//            let categories = UNNotificationCategory(identifier: "action", actions: [open,addmyfavorite,cancel], intentIdentifiers: [])
//            center.setNotificationCategories([categories])
//            // ローカル通知リクエストを作成
//            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//            // ユニークなIDを作る
//            let identifier = "L" + UUID().description
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//            // ローカル通知リクエストを登録
//            center.add(request){ (error : Error?) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                else{
//                    //構造体に追加し、その構造体を配列に保存。その配列をuserdefaaultに保存の処理を書くか。
//                    notifications = userDefaultOperationNotification.loadUserDefault()
//                    notification.id = identifier
//                    notification.setword = self.setword
//                    notifications.append(notification)
//                    userDefaultOperationNotification.saveUserDefault(array: notifications)
//                }
//            }
//        }//serchstart or geocodeの終わり
//    }
//}
