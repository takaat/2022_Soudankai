//
//  HomeView.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/29.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var meigen = ""
    @State private var auther = ""
    @EnvironmentObject private var coredatamodel: CoreDataModel

    var body: some View {
        NavigationView {
            VStack {
                Text(meigen)
                Text(auther)
            }
        }
        .onAppear {
            getMotto { meigen, auther in
                self.meigen = meigen
                self.auther = auther
                coredatamodel.addMotto(context: context, meigen: meigen, auther: auther)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
