//
//  Persistence.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/31.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MeigenSupplement")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    static var preview: PersistenceController = {
        let sample = [["細かい仕事に細分化すれば、さして困難なものはない。",
                       "ヘンリー・フォード"],
                      ["二つの矢を持つことなかれ。後の矢を頼みて初の矢になおざりの心あり。",
                       "吉田兼好"],
                      ["どんな大きな流れも、きっかけは一人の小さな行動から生まれます。",
                       "ダライ・ラマ14世"]]
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for num in 0..<3 {
            let newMotto = Motto(context: viewContext)
            newMotto.uuid = UUID()
            newMotto.timestamp = Date()
            newMotto.isFavorite = false
            newMotto.meigen = sample[num][0]
            newMotto.auther = sample[num][1]
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
