//
//  MuchGroupLiveViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import HandyJSON
import RxSwift
import RxCocoa

struct MuchGroupLiveViewModel {
    var title = BehaviorRelay<String?>(value: nil)
    var detail = BehaviorRelay<NSAttributedString?>(value: nil)
    var model:  MuchGroupListModel?

    init(model: MuchGroupListModel?) {
        
        self.model = model
        
        let _title = "\(model?.name ?? "") - 样式\(model?.type ?? 1)"
        self.title.accept(_title)
        
        let _detail = model?.desc ?? "这家伙很懒，什么都没留下～"
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        let attr = NSAttributedString(string: _detail, attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.detail.accept(attr)
    }
}


