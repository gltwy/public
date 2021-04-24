//
//  RootViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxCocoa
import RxSwift

class RootViewModel {

    private let disposeBag = DisposeBag()
    
    struct Input {
        let refresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[RootCellViewModel]>
    }
    
    func transform(input: Input) -> Output {
        let dataSource = BehaviorRelay<[RootCellViewModel]>(value: [])
        input.refresh.map {[weak self] (_) -> [RootCellViewModel] in
            return self?.dataSource ?? []
        }.bind(to: dataSource).disposed(by: disposeBag)
        return Output(items: dataSource)
    }
    
    private var dataSource: [RootCellViewModel] {
        get {
            let traits1 = RootCellViewModel(model: RootModel(title: "RxSwift特征序列Single、Maybe、Completable的使用",
                                                             targetVC: SMCViewController.self))
            
            let traits2 = RootCellViewModel(model: RootModel(title: "RxSwift特征序列Driver的使用，以及共享附加作用与非共享附加作用的区别？",
                                                             targetVC: DriveViewController.self))
            
            let bo = RootCellViewModel(model: RootModel(title: "RxSwift观察者AnyObserver、Binder的使用",
                                                             targetVC: BinderObserverViewController.self))
            
            let mf = RootCellViewModel(model: RootModel(title: "RxSwift操作符操作符map、flatMap、flatMapLatest、filter的使用与区别",
                                                             targetVC: MapFilterViewController.self))
            
            let mzc = RootCellViewModel(model: RootModel(title: "RxSwift操作符merge、zip、combinLatest的使用",
                                                             targetVC: MZCViewController.self))
            
            return [mzc,
                    mf,
                    bo,
                    traits2,
                    traits1]
        }
    }
}
