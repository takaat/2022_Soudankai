//
//  AddTimeNotification.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/09.
//

import SwiftUI

struct AddTimeNotification: View {
    
    @State var date = Date()
    
    var body: some View {
        NavigationView{
            VStack{
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.hourAndMinute,.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                //ここにスタイリングピッカーを入れるか。
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("キャンセル", action: {
                        //ここにキャンセルコードを書く
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("登録", action: {
                        //ここに登録コードを書く
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
