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
    let persistenceController = PersistenceController.shared
    @StateObject private var notificationModel = NotificationModel()
    @StateObject private var coredatamodel = CoreDataModel()
    @Environment(\.scenePhase) var scenePhase
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationModel)
                .environmentObject(coredatamodel)
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .inactive: break
                         //save(key: TypeOfkey.history.rawValue, input: historyModel.mottos)
                    case .active:
                        notificationModel.startup()
                    case .background: break

                    default: break

                    }
                }
        }
    }
}

//class AppDelegate: UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate,ObservableObject{
//
////    @ObservedObject var meigen = Meigen()
////    var showMeigen: Bool = false
//
////    init(showMeigen: Binding<Bool>) {
////        self._showMeigen  = showMeigen
////    }
//
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        center.requestAuthorization(options: [.alert,.sound,.badge]){(granted,_ error) in if granted{
//            print("許可を得た") }
//        }
//
//        return true
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner,.sound,.list])
//        print("フォアグランドで実行")
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
////        if response.actionIdentifier == "open"{
////
////            NotificationCenter.default.post(name: NSNotification.Name("ShowMeigen"), object: nil)
////        }
//
//        var myFavorites: [MyFavorite] = []
//        var myFavorite = MyFavorite()
//        let userDefaultOperation = UserDefaultOperation()
//
//        let userDefaultOperationNotification =  UserDefaultOperationNotification()
//        var notifications = [Notification]()
//        let identifier = response.notification.request.identifier
//
////        if response.actionIdentifier == "addmyfavorite"{
//            myFavorites = userDefaultOperation.loadUserDefault()
//            myFavorite.favoriteMeigen = response.notification.request.content.body
//            myFavorite.favoriteAuther = response.notification.request.content.subtitle
//            myFavorites.append(myFavorite)
//            userDefaultOperation.saveUserDefault(array: myFavorites)
////        }
//
//        notifications = userDefaultOperationNotification.loadUserDefault()
//
//        for notification in notifications{
//            if notification.id == identifier{
//                let index = notifications.firstIndex(of: notification)
//                notifications.remove(at: index ?? 0)
//                userDefaultOperationNotification.saveUserDefault(array: notifications)
//            }
//        }
//
//        completionHandler()
//
//    }
//
//}
//
