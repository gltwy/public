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
    var title = BehaviorRelay<NSAttributedString?>(value: nil)
    var targetVC = BehaviorRelay<UIViewController.Type?>(value: nil)
    
    init(model: RootModel) {
        let _detail = model.title ?? ""
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        let attr = NSAttributedString(string: _detail, attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.title.accept(attr)
        self.targetVC.accept(model.targetVC)
    }
}
