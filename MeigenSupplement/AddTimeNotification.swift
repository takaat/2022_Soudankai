//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct AddTimeNotification: View {
    
    @State var date = Date()
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                
                DatePicker(
                    "通知を配信する日時",selection: $date,displayedComponents:[.hourAndMinute,.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                Spacer()
                Button("通知済みの通知を表示"){
                    UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {noti in print(noti)})
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
//                ToolbarItem(placement: .navigationBarLeading){
//                    Button("キャンセル", action: {
//                        //ここにキャンセルコードを書く
//                    })
//                }
                ToolbarItem(placement: .navigationBarTrailing){
                    //登録したら、登録しましたとダイアログが出るようにしたいな。
                    Button("登録", action: {
                        //ここに登録コードを書く
                        TimeNotification(date: $date).basedOnTimeNotification()
                    })
                }
            }
        }
    }
}

struct AddTimeNotification_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeNotification()
    }
}
