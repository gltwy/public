//
//  RootCellViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxCocoa
import RxSwift

class RootCellViewModel: NSObject {
    var title = BehaviorRelay<String?>(value: nil)
    var targetVC = BehaviorRelay<UIViewController.Type?>(value: nil)
    
    init(model: RootModel) {
        self.title.accept(model.title)
        self.targetVC.accept(model.targetVC)
    }
}
