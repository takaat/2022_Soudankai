//
//  NotificationListView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/11.
//

import SwiftUI

struct NotificationListView: View {
    
    @State private var pendingNotification = PendingNotification()
    @State private var notificationRequests: [UNNotificationRequest] = []
    @State private var selectionValue: String? = ""
    @State private var notifications = [Notification]()
    @State private var userDefaultOperationNotification = UserDefaultOperationNotification()
    
    
    var body: some View {
        NavigationView{
            VStack{
                List(selection: $selectionValue){
                    ForEach(notificationRequests,id:\.identifier){ pendingRequest in
                        
                       
                        VStack{
                            Text(pendingRequest.identifier)
                            Text(pendingRequest.content.body)
                            
                        }
                    }
                    .onMove(perform: rowReplace )
                    .onDelete(perform: rowRemove )
                }
                .environment(\.editMode, .constant(.active))
                
                Button("全消去", action:  {UNUserNotificationCenter.current().removeAllPendingNotificationRequests()})//全消去の機能は、動作する
            }
            
        }
        .onAppear{
            notificationRequests = pendingNotification.getPendingNotification()
            notifications = userDefaultOperationNotification.loadUserDefault()
        }
        .toolbar { EditButton() }
    }
    
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        notificationRequests.move(fromOffsets: from, toOffset: to)
        
    }
    //行削除をする関数
    func rowRemove(offsets: IndexSet) {
        notificationRequests.remove(atOffsets: offsets) //通知を削除するメソッドに変更するか。
        
    }
    
    //これは構造体かクラスにする。関数ではViewに入れることができない。
    func getnotification(request:UNNotificationRequest,notifications: [Notification]) {
        
        for notification in notifications{
            if notification.id == request.identifier {
                //ここの処理をどうするか。
            }
        }
    }
}


struct NotificationListView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListView()
    }
}

class PendingNotification/*: Identifiable*/ {
    
    let center = UNUserNotificationCenter.current()
    var unNotificationRequests: [UNNotificationRequest] = []
    
    func getPendingNotification()->[UNNotificationRequest]{
        
        center.getPendingNotificationRequests(completionHandler: { notificationRequest in
            self.unNotificationRequests = notificationRequest})
        
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

