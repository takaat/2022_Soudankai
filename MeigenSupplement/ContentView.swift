//
//  ContentView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @ObservedObject var meigen = Meigen()
//    @State var date: Date = Date()
//    @State var inputword = ""
//    @State var setword = ""
    
    @State var show = false
    @State var arrayMyfavorite = [MyFavorite]()
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                NavigationLink( //これは通知から開いた時に実行される
                    destination: ShowMeigen(show:self.$show),
                    isActive: self.$show,
                    label: {
                        EmptyView()
                    })
                
                NavigationLink(
                    destination: FavoriteView(),
                    label: {
                        Text("お気に入りへ")
                    })
                    .padding()
                
                
                NavigationLink(
                    destination: ShowMeigen(show:self.$show),
                    label: {
                        Text("名言へ")
                    })
                
                Button(action: meigen.getMeigen) {
                    Text("ボタン")
                }
                .padding()
                
                Text(meigen.meigen)
                
                Text(meigen.auther)
                    .padding()
                
//                DatePicker("日時を選んでください", selection: $date)
//                    .padding()
                NavigationLink("日時による通知へ", destination: AddTimeNotification())
                    .padding()
//                Button("発火準備", action: {let timenotification = TimeNotification(date: $date,repeatTime: $repeatTime)
//                    timenotification.basedOnTimeNotification()
//                })
//                .padding()
                
                NavigationLink("位置情報による通知へ", destination: LocationView()).padding()
                
                Button("通知一覧の取得", action: {getPendingNotification()}).padding()
                
                NavigationLink("通知一覧の表示", destination: NotificationListView())
                
//                TextField("input",text: $inputword,onCommit: {setword = inputword})
//                    .padding()
//
//                Button("位置情報による発火", action: {
//                    let locationNotification = LocationNotification(setword: $setword)
//                    locationNotification.basedOnLocationNotification()
//                })
            }
        }
        .onAppear{
           
            NotificationCenter.default.addObserver(forName: NSNotification.Name("ShowMeigen"), object: nil, queue: .main, using: {(_) in self.show = true })
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getPendingNotification(){
    let center = UNUserNotificationCenter.current()
    center.getPendingNotificationRequests(completionHandler: {arrReq in
        for req in arrReq{
            
            guard let trigger = req.trigger else { return }
            
//            guard let catrigger = trigger as? UNCalendarNotificationTrigger else { return }
//            print("通知IDは\(req.identifier),トリガー条件は、\(trigger),次の通知は\(catrigger.nextTriggerDate())")
            print("通知IDは\(req.identifier),トリガーは\(trigger),内容は\(req.content)")
        }
    })
    
}
