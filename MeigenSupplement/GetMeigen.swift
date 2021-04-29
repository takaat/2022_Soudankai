//
//  GetMeigen.swift
//  MeigenSupplement
//
//  Created by 上田学 on 2021/04/04.
//

import Foundation

class Meigen: NSObject,ObservableObject,XMLParserDelegate{
    
    /*@ObservedObject、ObservableObject、@Publishedはセットで使うこと。
 「nw_protocol_get_quic_image_block_invoke dlopen libquic failed」エラーは出るが動作は
 きちんとできる。*/
    
   @Published var meigen = ""
   @Published var auther = ""
   private var element = ""
    
    func getMeigen(callback: @escaping () -> Void){
    
        guard let req_url = URL(string: "http://meigen.doodlenote.net/api?c=1") else{ return }
        let req = URLRequest(url: req_url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req,completionHandler: {(data,response,error) in session.finishTasksAndInvalidate()
            guard let data = data else{ return }
//            let str: String? = String(data: data, encoding: .utf8)
//            print(str!)
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            callback()
        })
        task.resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName
        if element == "response"{//開始タグが来たら、meigenとautherを初期化している。
            meigen = ""
            auther = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch element {
        case "meigen":
            meigen += string
        case "auther":
            auther += string
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
}
