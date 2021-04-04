//
//  ShowMeigen.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI

struct ShowMeigen: View{
    
    //    @State var showMeigen = false
    @ObservedObject var meigen = Meigen()
    @Binding var show: Bool
    @State var isFavorite = false
    @State private var myFavorites: [MyFavorite] = []
    @State private var myFavorite = MyFavorite()
    @State private var userDefaultOperation = UserDefaultOperation()
    
    var body: some View {
        
        VStack {
            Text(meigen.meigen)
                .frame(alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(.title2, design: .monospaced))
                .padding([.leading, .bottom, .trailing])
            
            HStack{
                
                Text(meigen.auther)
                    .frame(alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.body)
                    .padding([.leading, .bottom, .trailing])
                
                Spacer()
            }
            
            Button(action: {
                
                if isFavorite == true{
                    isFavorite = false
                    // お気に入りから削除する処理
                    myFavorites = userDefaultOperation.loadUserDefault()
                    myFavorites.removeLast()
                    userDefaultOperation.saveUserDefault(array: myFavorites)
                }
                else{
                    isFavorite = true
                    // お気に入りに登録する処理
//                    myFavorites = userDefaultOperation.loadUserDefault()
                    myFavorite.favoriteMeigen = meigen.meigen
                    myFavorite.favoriteAuther = meigen.auther
                    myFavorites.append(myFavorite)
                    userDefaultOperation.saveUserDefault(array: myFavorites)
                }
            }, label: {
                isFavorite==true ? Image(systemName: "heart.fill"):Image(systemName: "heart")
            })
            .frame(width: 300, height: 35, alignment: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
        }
        .onAppear{
            meigen.getMeigen()
        }
    }
}
    
    struct ShowMeigen_Previews: PreviewProvider {
        @State static var show = true
        static var previews: some View {
            ShowMeigen(show: $show)
        }
    }

