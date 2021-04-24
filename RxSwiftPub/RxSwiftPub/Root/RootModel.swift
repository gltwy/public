//
//  RootModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit

class RootModel {
    var title: String?
    var targetVC: UIViewController.Type?
    init(title: String?, targetVC: UIViewController.Type) {
        self.title = title
        self.targetVC = targetVC
    }
    deinit {
//        Logger("RootModel deinit")
    }
}
