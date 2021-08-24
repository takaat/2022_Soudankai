//
//  file.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/08/24.
//

import Foundation

func smple(){
    // ①プロジェクト内にある"capital.txt"のパス取得
    guard let fileURL = Bundle.main.url(forResource: "サンプルテキスト", withExtension: "txt")  else {
        fatalError("ファイルが見つからない")
    }
    
    // ②capital.txtファイルの内容をfileContents:Stringに読み込み
    guard let fileContents = try? String(contentsOf: fileURL) else {
        fatalError("ファイル読み込みエラー")
    }
    
    // ③ファイルの内容を"\n"で分割。
    var countries = fileContents.components(separatedBy: "\n")
    countries.removeLast()
    // ④１行づつ出力
    for capital in countries {
        let values = capital.components(separatedBy: ",")
        print("\(values[0])の首都は、\(values[1])です。")
    }
}
