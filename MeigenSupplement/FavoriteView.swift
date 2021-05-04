//
//  FavoriteView.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import SwiftUI

struct FavoriteView: View {
    
    //    @AppStorage("myfavoriteKey") var myFavorite = [MyFavorite]() //＝　初期値を使う。初期値をどうするか。
//        @State private var arrayMyfavorite = UserDefaults.standard.array(forKey: "myfavorite_Key") as? [MyFavorite] ?? []
//    @State private var arrayMyfavorite :[abc] =   [MyFavorite(meigen:"今日はとても天気がいいから、ユニクロに買い物にいくことになった。",auther:"上田　学"),MyFavorite(meigen:"ef",auther:"gh"),MyFavorite(meigen:"ij",auther:"kl"),MyFavorite(meigen:"介護",auther:"福祉")]
    //    @State var myFavorite: []
    @State private var myFavorites: [MyFavorite] = []
    let userDefaultOperation = UserDefaultOperation()
    
    var body: some View {
        
        NavigationView{
            List{
                ForEach(myFavorites,id:\.self){ favorite in
                    VStack(alignment: .leading, spacing: 3){
                        Text(favorite.favoriteMeigen)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                        Text(favorite.favoriteAuther)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.body)
                    }
                }
                .onMove(perform: rowReplace)
                .onDelete(perform: rowRemove)
            }
            .navigationBarItems(trailing: EditButton())
            
        }
        .onAppear{
            myFavorites = userDefaultOperation.loadUserDefault()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    // 行入れ替え処理
    func rowReplace(_ from: IndexSet, _ to: Int) {
        myFavorites.move(fromOffsets: from, toOffset: to)
        userDefaultOperation.saveUserDefault(array: myFavorites)
    }
    //行削除をする関数
    func rowRemove(offsets: IndexSet) {
        myFavorites.remove(atOffsets: offsets)
        userDefaultOperation.saveUserDefault(array: myFavorites)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    //@State static var arrayMyfavorite = [MyFavorite]()
    static var previews: some View {
        FavoriteView()
    }
}


struct MyFavorite: Identifiable,Codable,Hashable {
    var id = UUID()
    var favoriteMeigen = ""
    var favoriteAuther = ""
}

struct UserDefaultOperation {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let userDefault = UserDefaults.standard
    let key = "myfavorite_Key"
    
    func saveUserDefault(array:[MyFavorite]){
        guard let encodedValue = try? encoder.encode(array) else{ return }
        userDefault.set(encodedValue, forKey: key)
    }
    
    func loadUserDefault() -> [MyFavorite] {
        guard let savedValue = userDefault.data(forKey: key),
              let value = try? decoder.decode([MyFavorite].self, from: savedValue) else { return [MyFavorite]() }
        return value
    }
}
