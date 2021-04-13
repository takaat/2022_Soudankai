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
    
    var body: some View {
        NavigationView{
            VStack{
                List(selection: $selectionValue){
                    ForEach(notificationRequests,id:\.identifier){ pendingUNNotificationRequest in
                        VStack{
                            Text(pendingUNNotificationRequest.identifier)
                            Text(pendingUNNotificationRequest.content.body)
                        }
                    }
                    .onMove(perform: rowReplace )
                    .onDelete(perform: rowRemove )
                }
                .environment(\.editMode, .constant(.active))
                
                Button("全消去", action: {UNUserNotificationCenter.current().removeAllPendingNotificationRequests()})
            }
            
        }
        .onAppear{
            notificationRequests = pendingNotification.getPendingNotification()
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
