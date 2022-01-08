//
//  ContentView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI

struct ContentView: View {
    private enum Tag {
        case calendarView, locationView, homeView, notificationListView, historyView
    }

    @State private var selection: Tag = .homeView

    var body: some View {
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("日時")
                }
                .tag(Tag.calendarView)

            LocationView()
                .tabItem {
                    Image(systemName: "mappin.and.ellipse")
                    Text("場所")
                }
                .tag(Tag.locationView)

            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
                }
                .tag(Tag.homeView)

            NotificationListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("通知一覧")
                }
                .tag(Tag.notificationListView)

            HistoryView()
                .tabItem {
                    Image(systemName: "square.3.layers.3d.down.right")
                    Text("履歴")
                }
                .tag(Tag.historyView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
