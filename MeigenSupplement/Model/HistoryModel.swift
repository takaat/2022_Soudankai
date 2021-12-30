//
//  HistoryManager.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/30.
//

import Foundation

class HistoryModel: ObservableObject {
    @Published var mottos: [Motto] = load(key: TypeOfkey.history.rawValue)
    private let limitNumber = 30

    func manageMottos() { // 30件を超えたら、古いものから削除するようにする。日付降順に並び替えたりする。削除はお気に入りを除く。disappearで発動させる
        // お気に入りの順序は、ユーザーが変えれるようにする。
    }
}
