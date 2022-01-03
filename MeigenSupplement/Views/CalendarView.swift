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

    var body: some View {
        Spacer()
        VStack(spacing: 30.0) {
            DatePicker(
                "通知を配信する日時",
                selection: $date,
                displayedComponents: [.hourAndMinute, .date])
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
//            .cornerRadius(20)
            .buttonStyle(.bordered)
//            .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
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
