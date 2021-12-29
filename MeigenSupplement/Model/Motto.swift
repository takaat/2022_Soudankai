//
//  Motto.swift
//  MeigenSupplement
//
//  Created by mana on 2021/12/27.
//

import Foundation
import SwiftUI

struct Motto: Hashable,Codable,Identifiable {
    var id = UUID()
    var meigen: String
    var auther: String
    var isfavorite: Bool = false
}
