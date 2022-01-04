//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct CalendarView: View {
    @State private var date = Date()
    @State private var isShowAlert = false
    private let dateRange = Date()...

    var body: some View {
        VStack(spacing: 30.0) {
            Spacer()
            DatePicker("", selection: $date, in: dateRange)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("登 録") {
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                getMotto { meign, auther in
                    setNotification(meigen: meign,
                                    auther: auther,
                                    typeOfTrigger: .calendar(dateComponents))}
                isShowAlert = true
            }
            .buttonStyle(.bordered)
            .alert("登録完了",
                   isPresented: $isShowAlert,
                   actions: {},
                   message: {Text("時間指定で登録しました。")})
            Spacer()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
