//
//  MuchGroupBannerViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

struct MuchGroupBannerViewModel {
    let title = BehaviorRelay<String?>(value: nil)
    let detail = BehaviorRelay<String?>(value: nil)
    let image = BehaviorRelay<UIImage?>(value: nil)
    let model: MuchGroupListModel?

    init(model: MuchGroupListModel?) {
        
        self.model = model
        
        let _title = "\(model?.name ?? "") - 样式\(model?.type ?? 1)"
        self.title.accept(_title)
        
        let _detail = "随机数 - \(arc4random() % 10000)"
        self.detail.accept(_detail)
        
        self.image.accept(UIImage(named: model?.urls?.pic ?? ""))
    }
}


