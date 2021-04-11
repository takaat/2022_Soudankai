//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct AddTimeNotification: View {
    
    @State var date = Date()
    @State var repeatTime = 0
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                
                DatePicker(
                    "通知を配信する日時",selection: $date,displayedComponents:[.hourAndMinute,.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

                Spacer()
                
                HStack {
                    Image(systemName: "repeat").padding(.leading)
                    Text("繰り返し")
//                        .padding(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
                
                Picker(selection: $repeatTime, label: Text("繰り返し")) {
                    Text("しない").tag(0)
                    Text("毎日").tag(1)
                    Text("毎週").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
                Spacer()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
//                ToolbarItem(placement: .navigationBarLeading){
//                    Button("キャンセル", action: {
//                        //ここにキャンセルコードを書く
//                    })
//                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("登録", action: {
                        //ここに登録コードを書く
                        TimeNotification(date: $date, repeatTime: $repeatTime).basedOnTimeNotification()
                    })
                }
            }
        }
    }
}

struct AddTimeNotification_Previews: PreviewProvider {
    static var previews: some View {
        AddTimeNotification()
    }
}
