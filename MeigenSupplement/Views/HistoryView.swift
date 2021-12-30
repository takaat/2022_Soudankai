//
//  HistoryView.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/30.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var history: HistoryModel
    @State private var isShowfavorite = false

    private enum HistoryOrFavorite: Bool {
        case history = false
    }

    var filteredMottos: [Motto] {
        history.mottos.filter { motto in
            !isShowfavorite || motto.isfavorite }
    }

    var body: some View {



        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(HistoryModel())
    }
}
