//
//  MuchGroupSection.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import HandyJSON

enum MuchGroupSection {//决定将来分组的类型
    case banner(title: String, items: [MuchGroupSectionItem])
    case live(title: String, items: [MuchGroupSectionItem])
}

enum MuchGroupSectionItem {//根据分组类型用于每个cell展示的viewModel
    case banner(cellViewModel: MuchGroupBannerViewModel)
    case live(cellViewModel: MuchGroupLiveViewModel)
}

//实现RxDataSources用于提供数据源支持必须遵守的协议SectionModelType
extension MuchGroupSection: SectionModelType {
    
    typealias Item = MuchGroupSectionItem
    
    var items: [MuchGroupSectionItem] {
        switch self {
        case .banner(_, let items):
            return items
        case .live(_, let items):
            return items
        }
    }
    
    init(original: MuchGroupSection, items: [MuchGroupSectionItem]) {
        self = original
    }
}
