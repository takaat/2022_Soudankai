//
//  File.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/31.
//

import Foundation
import CoreData

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
//　削除と並び替えは、HistoryView内で定義するか。

//    func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { tasks[$0] }.forEach(context.delete)
//                try? context.save()
//        }
//    }
