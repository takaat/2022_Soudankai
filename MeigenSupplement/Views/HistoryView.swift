//
//  HistoryView.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/30.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Motto.timestamp, ascending: false)],
        animation: .default)
    private var mottos: FetchedResults<Motto>
    @EnvironmentObject private var cdmodel: CDModel

    var body: some View {
        List {
            ForEach(mottos) { motto in
                HStack {
                    Text(motto.meigen ?? "")
                    Text(motto.auther ?? "")
                }
            }
        }
    }
}


//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
