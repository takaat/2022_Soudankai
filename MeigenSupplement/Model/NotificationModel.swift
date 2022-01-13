//
//  NotificationModel.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/30.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let context = PersistenceController.shared.container.viewContext
    // @Environmentは親ビューから子ビューに伝播するものなのでクラスには伝播しない。よってクラス内に新たにcontextを宣言する必要がある。
    private let coreDataModel = CoreDataModel()
    private let center = UNUserNotificationCenter.current()

    enum TypeOfTrigger {
        case calendar(DateComponents)
        case location(CLRegion)

        var trigger: UNNotificationTrigger {
            switch self {
            case .calendar(let date):
                return UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            case .location(let region):
                return UNLocationNotificationTrigger(region: region, repeats: false)
            }
        }
    }

    func startup() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("通知許可を得た")
            }
        }
    }

    func getMotto(completion: @escaping (String, String) -> Void) {
        struct ResultJson: Codable {
            let meigen: String?
            let auther: String?
        }

        guard let requestUrl = URL(string: "https://meigen.doodlenote.net/api/json.php?c=1") else { return }
        let request = URLRequest(url: requestUrl)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, _, error in session.finishTasksAndInvalidate()

            if let error = error {
                print(error)
                fatalError("エラーが出ました。エラー内容：\(error.localizedDescription)")
            }

            do {
                guard let data = data else { return }
                let results = try JSONDecoder().decode([ResultJson].self, from: data)
                completion(results[0].meigen ?? "", results[0].auther ?? "")
            } catch {
                print(error)
                fatalError("エラーが出ました。エラー内容：\(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func setNotification(meigen: String, auther: String, typeOfTrigger: TypeOfTrigger) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        let action = UNNotificationAction(identifier: "action", title: "アプリで確認", options: .foreground)
        let category = UNNotificationCategory(identifier: "category",
                                              actions: [action],
                                              intentIdentifiers: [""],
                                              options: [])
        center.setNotificationCategories([category])
        content.sound = .default
        content.subtitle = auther
        content.body = meigen
        content.categoryIdentifier = "category"
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: typeOfTrigger.trigger)
        center.add(request) { error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        let meigen = notification.request.content.body
        let auther = notification.request.content.subtitle
        coreDataModel.addMotto(context: context, meigen: meigen, auther: auther)
        completionHandler([.banner, .sound, .list])
        print("フォアグランドで通知発火")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action":
            let meigen = response.notification.request.content.body
            let auther = response.notification.request.content.subtitle
            coreDataModel.addMotto(context: context, meigen: meigen, auther: auther)
            print("didReciveのactionを実行した")
        default:
            break
        }
        completionHandler()
        print("バックグランドで通知発火")
    }
}
