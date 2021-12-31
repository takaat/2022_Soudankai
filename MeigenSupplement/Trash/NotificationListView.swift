//
//  NotificationListView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/11.
//

import SwiftUI
import Foundation

struct NotificationListView: View {

    @State private var isShowAlert = false

    var body: some View {
        NavigationView{

            VStack{
                NotificationDisplayView()
                    .padding(.vertical)

                if #available(iOS 15.0, *){
                    Button("全消去", action:  {
                        //ユーザーデフォルトを消さないとリストからは消えない。
                        isShowAlert = true
                    })
                        .padding()
                        .alert("本当に全消去しますか？", isPresented: $isShowAlert){
                            Button(role: .destructive, action: {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                UserDefaultOperationNotification().allRemoveUserDefault()
                            }, label: {
                                Text("消去")
                            })
                            Button(role: .cancel, action: {}, label: {Text("キャンセル")})
                        }
                }
                else{
                    Button("全消去", action:  {
                        //ユーザーデフォルトを消さないとリストからは消えない。
                        isShowAlert = true
                    })
                        .padding()
                        .alert(isPresented: $isShowAlert){
                            Alert(title: Text("本当に全消去しますか？"), primaryButton: .cancel(), secondaryButton: .destructive(Text("消去"),action: {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                UserDefaultOperationNotification().allRemoveUserDefault()
                            })
                            )}
                }
            }
            .toolbar { EditButton() }
        }
    }
}

    struct NotificationListView_Previews: PreviewProvider {
        static var previews: some View {
            NotificationListView()
        }
    }





    //struct TimeDisplayView: View{
    //
    //    @State private var pendingNotification = PendingNotification()
    //    @State private var notificationRequests: [UNNotificationRequest] = []
    //
    //    var body: some View{
    //
    //        VStack{
    //            Text("日時指定の通知")
    //            List{
    //                ForEach(notificationRequests,id:\.self){ request in
    //
    //                    if request.identifier.hasPrefix("T") {
    //
    //                        let trigger = request.trigger as? UNCalendarNotificationTrigger
    //                        let dateComponents = trigger?.dateComponents
    //
    //                        if let dateComponents = dateComponents{
    //                            let date = Calendar.current.date(from: dateComponents)
    //
    //                            if dateComponents.month != nil{
    //
    //                                HStack{
    //                                    Text(date ?? Date(), style: .date)
    //                                    Text(date ?? Date(), style: .time)
    //                                }
    //                            }
    //                            else if dateComponents.weekday != nil{//ここを関数として切り分ける。
    //                                let stringWeekday = everyWeek(dateComponents)
    //
    //                                HStack{
    //                                    Text("毎週")
    //                                    Text("\(stringWeekday)")
    //                                    Text(date ?? Date(), style: .time)
    //                                }
    //                            }
    //                            else{
    //
    //                                HStack{
    //                                    Text("毎日")
    //                                    Text(date ?? Date(), style: .time)
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //                .onMove(perform: rowReplace )
    //                .onDelete(perform: rowRemove )
    //            }
    //        }
    //        .onAppear{
    //            notificationRequests = pendingNotification.getPendingNotification()
    //        }
    //    }
    //    // 行入れ替え処理
    //    func rowReplace(_ from: IndexSet, _ to: Int) {
    //        notificationRequests.move(fromOffsets: from, toOffset: to)
    //
    //    }
    //    //行削除をする関数
    //    func rowRemove(offsets: IndexSet) {
    //        let identifier = notificationRequests[offsets[offsets.startIndex]].identifier
    //        notificationRequests.remove(atOffsets: offsets)
    //        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    //    }
    //
    //    func everyWeek(_ dateComponents: DateComponents) -> String{
    //        var stringWeekday = ""
    //        switch dateComponents.weekday {
    //        case 1: stringWeekday = "日曜日"
    //        case 2: stringWeekday = "月曜日"
    //        case 3: stringWeekday = "火曜日"
    //        case 4: stringWeekday = "水曜日"
    //        case 5: stringWeekday = "木曜日"
    //        case 6: stringWeekday = "金曜日"
    //        case 7: stringWeekday = "土曜日"
    //        default:break
    //        }
    //        return stringWeekday
    //    }
    //}



    // 通知が出た後にuserdefaultから削除する処理を書く必要がある。

    struct NotificationDisplayView: View {

        //    @State private var pendingNotification = PendingNotification()
        //    @State private var notificationRequests: [UNNotificationRequest] = []
        @State private var notifications = [Notification]()
        @State private var userDefaultOperationNotification = UserDefaultOperationNotification()

        var body: some View{

            VStack{

                List{
                    ForEach(notifications,id:\.id){ notification in
                        //ここに関数を入れる
                        if notification.id.hasPrefix("T") {
                            //                        let formatter = DateFormatter()
                            //                        formatter.dateFormat = "MMM, dd, YYYY"
                            //                        let displayString = formatter.string(from: notification.date)
                            HStack{
                                Text(notification.date, style: .date )
                                Text(notification.date, style: .time )
                            }
                        }
                        else{
                            Text(notification.setword)
                        }
                    }
                    .onMove(perform: rowReplace )
                    .onDelete(perform: rowRemove)
                }
            }
            .onAppear{
                //            notificationRequests = pendingNotification.getPendingNotification()
//                print("NotificationDisplayViewのオンアピア作動")
                notifications = userDefaultOperationNotification.loadUserDefault()
                removeDeliveredNotificationList()
            }
        }

        // 行入れ替え処理
        func rowReplace(_ from: IndexSet, _ to: Int) {
            notifications.move(fromOffsets: from, toOffset: to)
            userDefaultOperationNotification.saveUserDefault(array: notifications)

        }
        //行削除をする関数
        func rowRemove(offsets: IndexSet) {
            let identifier = notifications[offsets[offsets.startIndex]].id
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            notifications.remove(atOffsets: offsets)
            userDefaultOperationNotification.saveUserDefault(array: notifications)
            //        for notificaition in notifications{
            //            if notificaition.id == identifier{
            //                let index = notifications.firstIndex(of: notificaition)
            //                notifications.remove(at: index ?? 0)
            //                userDefaultOperationNotification.saveUserDefault(array: notifications)
            //            }
            //        }
        }
        //通知済みの通知をリストから削除する処理
        func removeDeliveredNotificationList(){
            UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {deliverdNotifications in
                for deliverdNotification in deliverdNotifications{
                    for notification in notifications {
                        if deliverdNotification.request.identifier == notification.id{
                            notifications.remove(at: notifications.startIndex)
                            userDefaultOperationNotification.saveUserDefault(array: notifications)
                        }
                    }
                }
            })
        }




        //    func locationNotification(_ request: UNNotificationRequest) -> (String,Bool){
        //
        //        for notificaition in notifications{
        //            if notificaition.id == request.identifier{
        //                return (notificaition.setword,notificaition.repeatLocation)
        //            }
        //        }
        //        return ("",false)
        //    }
    }




    //struct ReturnString {
    //
    //    let calender = Calendar.current
    //    let dateFormatter = DateFormatter()
    //
    //    func convertString(notification: Notification) -> String{
    //        guard let date = calender.date(from: notification.dateComponent) else{
    //            return "アンラップ失敗です。"
    //        }
    //        return dateFormatter.string(from: date)
    //    }
    //}


    //class PendingNotification/*: Identifiable*/ {
    //
    //    let center = UNUserNotificationCenter.current()
    //    var unNotificationRequests: [UNNotificationRequest] = []
    //
    //    func getPendingNotification() -> [UNNotificationRequest]{
    //
    //        center.getPendingNotificationRequests(completionHandler: { notificationRequest in
    //            self.unNotificationRequests = notificationRequest
    //            //            guard let a = notificationRequest.first?.trigger as? UNCalendarNotificationTrigger else { return}
    //            //            let month = a.dateComponents.month
    //            //            let day = a.dateComponents.date?.description
    //
    //        })
    //
    //        return unNotificationRequests
    //
    //    }
    //}

    struct Notification: Identifiable,Codable,Hashable {
        var id = ""

        var repeatTime = 0
        var date = Date()

        var repeatLocation = false
        var setword = ""
    }

    struct UserDefaultOperationNotification {

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let userDefault = UserDefaults.standard
        let key = "notification_Key"

        func saveUserDefault(array:[Notification]){
            guard let encodedValue = try? encoder.encode(array) else{ return }
            userDefault.set(encodedValue, forKey: key)
        }

        func loadUserDefault() -> [Notification] {
            guard let savedValue = userDefault.data(forKey: key),
                  let value = try? decoder.decode([Notification].self, from: savedValue) else { return [Notification]() }
            return value
        }

        //全消去ボタンを押すとユーザーデフォルトから削除する処理
        func allRemoveUserDefault() {
            userDefault.set([], forKey: key)
        }
    }


    //                        if /*let day = trigger?.dateComponents.day,*/
    //                           let hour = trigger?.dateComponents.hour,
    //                           let min = trigger?.dateComponents.minute{
    //                            Text("\(hour)時\(min)分です")
    //                        }
    //                        if let date = trigger?.dateComponents.date{
    //                            HStack{
    //                                Text(date, style: .date)
    //                                Text(date, style: .time)
    //                            }
    //                        }
    //                        else{
    //                            Text("dateComponentsアンラップできません。")
    //
    //                        }
    //                        Group{

    //                            let month = trigger!.dateComponents.month
    //                        let date = trigger.dateComponents.hour
    //                            Text(String(month!))

    //                        Text(date)
    //                        }
    //                        VStack{
    //                            Text(notification.setword)
    //                            Text(notification.dateComponent.description)
    //                            Text(returnString.convertString(notification: notification))
    //                        }
    //どこかでdateComponentsにCalendarを設定する必要がある。
    //                                dateComponents.calendar = Calendar.current

    //                                if dateComponents.month != nil{
    //                                else if dateComponents.weekday != nil{
    //                                    switch dateComponents.weekday {
    //                                    case 1: weekday = "日曜日"
    //                                    case 2: weekday = "月曜日"
    //                                    case 3: weekday = "火曜日"
    //                                    case 4: weekday = "水曜日"
    //                                    case 5: weekday = "木曜日"
    //                                    case 6: weekday = "金曜日"
    //                                    case 7: weekday = "土曜日"
    //                                    default: break
    //                                    }
    //                                    HStack{
    //                                        Text("毎週\(weekday)")
    //                                        Text(dateComponents.date ?? Date(), style: .time)
    //                                    }
    //                                }
    //                            else{
    //                                HStack{
    //                                    Text("毎日")
    //                                    Text(dateComponents.date ?? Date(), style: .time)
    //                                }
    //                            }
