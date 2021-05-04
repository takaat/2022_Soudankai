//
//  MeigenSupplementApp.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI
import UserNotifications
import CoreLocation

@main
struct MeigenSupplementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate,ObservableObject{
    
//    @ObservedObject var meigen = Meigen()
//    var showMeigen: Bool = false
    
//    init(showMeigen: Binding<Bool>) {
//        self._showMeigen  = showMeigen
//    }
    
    private var myFavorites: [MyFavorite] = []
    private var myFavorite = MyFavorite()
    let userDefaultOperation = UserDefaultOperation()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert,.sound,.badge]){(granted,_ error) in if granted{
            print("許可を得た") }
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.list])
        print("フォアグランドで実行")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        if response.actionIdentifier == "open"{
//
//            NotificationCenter.default.post(name: NSNotification.Name("ShowMeigen"), object: nil)
//        }
        
        if response.actionIdentifier == "addmyfavorite"{
            myFavorites = userDefaultOperation.loadUserDefault()
            myFavorite.favoriteMeigen = response.notification.request.content.body
            myFavorite.favoriteAuther = response.notification.request.content.subtitle
            myFavorites.append(myFavorite)
            userDefaultOperation.saveUserDefault(array: myFavorites)
        }
        
        let isrepeat = response.notification.request.trigger?.repeats
        let identifier = response.notification.request.identifier
        if isrepeat == true {
            if identifier.hasPrefix("T") == true {
//                TimeNotification(date: $date, repeatTime: $repeatTime).basedOnTimeNotification()
            }
            else{
                
            }
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
        
        completionHandler()
        
    }
    
}

