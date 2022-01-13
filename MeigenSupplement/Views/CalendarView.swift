//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var isShowRegisteredAlert = false
    private let dateRange = Date()...
    @EnvironmentObject private var notificationModel: NotificationModel

    var body: some View {
        VStack(spacing: 30.0) {
            Spacer()
            DatePicker("", selection: $selectedDate, in: dateRange)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("登 録") {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
                notificationModel.getMotto { meign, auther in
                    notificationModel.setNotification(meigen: meign,
                                    auther: auther,
                                    typeOfTrigger: .calendar(dateComponents))}
                isShowRegisteredAlert = true
            }
            .buttonStyle(.bordered)
            .alert("登録完了",
                   isPresented: $isShowRegisteredAlert,
                   actions: {},
                   message: {Text("時間指定で登録しました。")})
            Spacer()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(NotificationModel())
    }
}
