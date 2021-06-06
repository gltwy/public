//
//  EditModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit

class EditModel {
    var title: String?
    var index: Int
    init(title: String?) {
        self.title = title
        self.index = Self.random
    }
    
    static var random: Int {
        Int(arc4random() % 10000)
    }
}
