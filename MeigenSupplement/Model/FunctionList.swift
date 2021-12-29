//
//  GetMeigen.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation
import UserNotifications
import CoreLocation

func getMotto(completion: @escaping (String, String) -> Void) {

    struct ResultJson: Codable {
        let meigen: String?
        let auther: String?
    }

    guard let requestUrl = URL(string: "https://meigen.doodlenote.net/api/json.php?c=1") else { return }
    let request = URLRequest(url: requestUrl)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    let task = session.dataTask(with: request) { (data,response,error) in session.finishTasksAndInvalidate()

        if let error = error {
            print(error)
            fatalError("エラーが出ました。エラー内容：" + error.localizedDescription)
        }

        do {
            guard let data = data else { return }
            let results = try JSONDecoder().decode([ResultJson].self,from: data)
            completion(results[0].meigen ?? "", results[0].auther ?? "")
        }
        catch{
            print(error)
            fatalError("エラーが出ました。エラー内容：" + error.localizedDescription)
        }
    }

    task.resume()

}

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

// 今は、単純に通知を登録する処理だけを記述する。のちにuserdefaultを追加するかも
func setNotification(meigen: String, auther: String, typeOfTrigger: TypeOfTrigger) {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.subtitle = auther
    content.body = meigen
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: typeOfTrigger.trigger)
    center.add(request) { error in
        if let error = error {
            fatalError(error.localizedDescription)
        }
    }
}

func save<T>(key: String, input:T) where T: Codable {
    let encoder = JSONEncoder()
    do {
        let encodedValue = try encoder.encode(input)
        UserDefaults.standard.set(encodedValue, forKey: key)
    } catch  {
        fatalError(error.localizedDescription)
    }
}

func load<T>(key: String) -> T where T: Codable { // 出力するときは型を明示すること
    let decoder = JSONDecoder()
    guard let savedValue = UserDefaults.standard.data(forKey: key) else { fatalError() }
    do {
        let value = try decoder.decode(T.self, from: savedValue)
        return value
    } catch {
        fatalError(error.localizedDescription)
    }
}

// ユーザーデフォルトの消去メソッドはあり。