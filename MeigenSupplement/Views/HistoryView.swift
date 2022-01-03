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
    @EnvironmentObject private var coredatamodel: CoreDataModel
    @State private var isShowFavorite = false

    var filterdMottos: [Motto] {
        mottos.filter({ motto in
            (!isShowFavorite || motto.isFavorite) })
        }

    var body: some View {
        NavigationView {
            List {
                Toggle("お気に入りのみ表示", isOn: $isShowFavorite)
                ForEach(filterdMottos) { motto in
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text(motto.meigen ?? "")
                            Text(motto.auther ?? "")
                                .font(.footnote)
                        }
                        Spacer()
                        Button(action: {
                            motto.isFavorite.toggle()
                            try? context.save()
                        }, label: {
                            Image(systemName: motto.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(motto.isFavorite ? .yellow : .gray)})
                    }
                }
                .onDelete { indexSet in
                    deleteItems(offsets: indexSet)
                }
                .onMove(perform: nil)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { mottos[$0] }.forEach(context.delete)
            try? context.save()
        }
    }

    private func moveItems() {
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
