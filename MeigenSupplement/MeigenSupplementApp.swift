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
        
        if response.actionIdentifier == "open"{
            
            NotificationCenter.default.post(name: NSNotification.Name("ShowMeigen"), object: nil)
        }
        
        completionHandler()
        
    }
    
}

