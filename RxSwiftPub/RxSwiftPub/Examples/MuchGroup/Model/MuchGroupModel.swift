//
//  MuchGroupModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import HandyJSON

struct MuchGroupModel: HandyJSON {

    var data: [MuchGroupListModel]?
    
    static var json: [String : Any] {
        guard let path = Bundle.main.path(forResource: "muchgroup", ofType: "json") else { throwError }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { throwError }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else { throwError }
        guard let dict = jsonData as? [String : Any] else { throwError }
        return dict
    }
    
    static var throwError: Never {
        fatalError("请导入文件并检查文件格式是否正确")
    }
    
    init() { }
}

struct MuchGroupListModel: HandyJSON {
    var name: String? //用于显示名称
    var urls: MuchGroupListUrlModel? //图片模型-获取图片名称
    var type: Int? //cell的显示类型
    var desc: String? //用于显示描述信息
    init() { }
}

struct MuchGroupListUrlModel: HandyJSON {
    var pic: String?
    init() { }
}
