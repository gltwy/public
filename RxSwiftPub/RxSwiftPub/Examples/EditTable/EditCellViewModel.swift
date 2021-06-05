//
//  EditCellViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxCocoa
import RxSwift

class EditCellViewModel: NSObject {
    var title = BehaviorRelay<String?>(value: nil)
    
    init(model: EditModel) {
        self.title.accept("\(model.title ?? "") - 随机数 - \(model.index)")
    }
}
