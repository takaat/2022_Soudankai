//
//  NotificationListView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/11.
//

import SwiftUI
import Foundation

struct NotificationListView: View {
    
    @State private var pendingNotification = PendingNotification()
    @State private var notificationRequests: [UNNotificationRequest] = []
    @State private var selectionValue: String? = ""
    @State private var notifications = [Notification]()
    @State private var userDefaultOperationNotification = UserDefaultOperationNotification()
    @State var weekday = ""
//    let dateComponent = DateComponents(calendar: Calendar.current)
    let returnString = ReturnString()
    
    var body: some View {
        NavigationView{
            VStack{
                Text("日時指定の通知")
                List{
                    ForEach(notificationRequests,id:\.self){ request in
                        
                        if request.identifier.hasPrefix("T") {
                            
                            let trigger = request.trigger as? UNCalendarNotificationTrigger
                           
                            if let dateComponents =  trigger?.dateComponents{
                                //どこかでdateComponentsにCalendarを設定する必要がある。
//                                dateComponents.calendar = Calendar.current
                                
                                if dateComponents.month != nil{
                                    
                                    VStack{
                                        Text("\(dateComponents.year ?? 0)年\(dateComponents.month ?? 0)月\(dateComponents.day ?? 0)日\(dateComponents.hour ?? 0)時\(dateComponents.minute ?? 0)分")
                                        //                                        Text(dateComponent.date ?? Date(), style: .date)
                                        //                                        Text(dateComponent.date ?? Date(), style: .time)
                                    }
                                    
                                }
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
                                else{
                                    HStack{
                                        Text("毎日")
                                        Text(dateComponents.date ?? Date(), style: .time)
                                    }
                                }
                                
                            }
                        }
                        else{
                            Text("nextTriggerアンラップ失敗")
                        }
                    }.onMove(perform: rowReplace )
                    .onDelete(perform: rowRemove )
                }
                
                Text("場所指定の通知")
                
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
                
            }
            
        }
        .environment(\.editMode, .constant(.active))
        .onAppear{
            notificationRequests = pendingNotification.getPendingNotification()
            notifications = userDefaultOperationNotification.loadUserDefault()
        }
        Button("全消去", action:  {UNUserNotificationCenter.current().removeAllPendingNotificationRequests()})//全消去の機能は、動作する
        
        
    }
    
    //        .toolbar { EditButton() }
    
    
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        notificationRequests.move(fromOffsets: from, toOffset: to)
        
    }
    //行削除をする関数
    func rowRemove(offsets: IndexSet) {
        notificationRequests.remove(atOffsets: offsets) //通知を削除するメソッドに変更するか。
        
    }
    
    //これは構造体かクラスにする。関数ではViewに入れることができない。
    //    func getnotification(_ request:UNNotificationRequest)  {
    //        guard let trigger = request.trigger as? UNCalendarNotificationTrigger,
    //              let date = trigger.dateComponents.date else{ return }
    //        Text(date, style: .date)
    
    //         Text("a")
    //        for notification in notifications{
    //            if notification.id == request.identifier {
    //                //ここの処理をどうするか。
    //            }
    //        }
}





struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}

struct ReturnString {
    
    let calender = Calendar.current
    let dateFormatter = DateFormatter()
    
    func convertString(notification: Notification) -> String{
        guard let date = calender.date(from: notification.dateComponent) else{
            return "アンラップ失敗です。"
        }
        return dateFormatter.string(from: date)
    }
}


class PendingNotification/*: Identifiable*/ {
    
    let center = UNUserNotificationCenter.current()
    var unNotificationRequests: [UNNotificationRequest] = []
    
    func getPendingNotification() -> [UNNotificationRequest]{
        
        center.getPendingNotificationRequests(completionHandler: { notificationRequest in
            self.unNotificationRequests = notificationRequest
            //            guard let a = notificationRequest.first?.trigger as? UNCalendarNotificationTrigger else { return}
            //            let month = a.dateComponents.month
            //            let day = a.dateComponents.date?.description
            
        })
        
        return unNotificationRequests
        
    }
}

struct Notification: Identifiable,Codable,Hashable {
    var id = ""
    
    var repeatTime = 0
    var dateComponent = DateComponents()
    
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
}

