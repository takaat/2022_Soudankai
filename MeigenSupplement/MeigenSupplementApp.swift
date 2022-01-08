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
    private let persistenceController = PersistenceController.shared
    @StateObject private var notificationModel = NotificationModel()
    @StateObject private var coreDataModel = CoreDataModel()
    @Environment(\.scenePhase) var scenePhase
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(notificationModel)
                .environmentObject(coreDataModel)
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .inactive:
                         // save(key: TypeOfkey.history.rawValue, input: historyModel.mottos)
                        notificationModel.startup()
                    case .active:
                        break
                    case .background: break

                    default: break
                    }
                }
        }
    }
}
