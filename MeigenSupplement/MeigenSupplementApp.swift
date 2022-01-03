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
                         // save(key: TypeOfkey.history.rawValue, input: historyModel.mottos)
                    case .active:
                        notificationModel.startup()
                    case .background: break

                    default: break
                    }
                }
        }
    }
}
