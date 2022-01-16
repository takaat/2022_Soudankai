//
//  File.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/31.
//

import Foundation
import CoreData
// MARK: CoreDataに登録する処理
class CoreDataModel: NSObject, ObservableObject {
    func addMotto(context: NSManagedObjectContext, meigen: String, auther: String) {
        let newMotto = Motto(context: context)
        newMotto.uuid = UUID()
        newMotto.timestamp = Date()
        newMotto.isFavorite = false
        newMotto.meigen = meigen
        newMotto.auther = auther

        do {
            try context.save()
        } catch {
            let error = error
            print("addMottoの失敗\(error)\n\(error.localizedDescription)")
        }
    }
}
