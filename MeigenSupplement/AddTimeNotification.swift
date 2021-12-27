//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct AddTimeNotification: View {
    
    @State var date = Date()
    @State private var isShowAlert = false
    
    var body: some View {
        NavigationView{
            VStack{
//                Spacer()
                
                DatePicker(
                    "通知を配信する日時",selection: $date,displayedComponents:[.hourAndMinute,.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                if #available(iOS 15.0, *){
                    Button("登 録", action: {
                        //ここに通知を設定すること})
                        TimeNotification(date: $date).basedOnTimeNotification()
                        isShowAlert = true
                    })
//                        .frame(width: 80, height:50 )
//                        .background(Color(.cyan))
                        .cornerRadius(20)
                        .buttonStyle(.bordered)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .alert("登録完了", isPresented: $isShowAlert) {
//                                    Button("了解") {
//                                        // 了解ボタンが押された時の処理
//                                    }
                        } message: {
                            Text("時間指定で登録しました。")
                        }
                }
                else{
                    Button("登 録", action: {
                        //ここに通知を設定すること})
                        TimeNotification(date: $date).basedOnTimeNotification()
                        isShowAlert = true
                    })
                        .frame(width: 80, height:50 )
//                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .alert(isPresented: $isShowAlert){
                            Alert(title: Text("登録完了"), message: Text("時間指定で登録しました。"))
                        }
                }
                
                
                
                Spacer()
//                Button("通知済みの通知を表示"){
//                    UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {noti in print(noti)})
//                }
                
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar{
////                ToolbarItem(placement: .navigationBarLeading){
////                    Button("キャンセル", action: {
////                        //ここにキャンセルコードを書く
////                    })
////                }
//                ToolbarItem(placement: .navigationBarTrailing){
//                    //登録したら、登録しましたとダイアログが出るようにしたいな。
//                    Button("登録", action: {
//                        //ここに登録コードを書く
//                        TimeNotification(date: $date).basedOnTimeNotification()
////                        isShowAlert = true
//                    })
//                }
//            }
        }
    }
}

struct AddTimeNotification_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeNotification()
    }
}
