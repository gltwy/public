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
            let traits1 = RootCellViewModel(model: RootModel(title: "03: RxSwift特征序列Single、Maybe、Completable的使用",
                                                             targetVC: SMCViewController.self))
            
            let traits2 = RootCellViewModel(model: RootModel(title: "04: RxSwift特征序列Driver的使用，以及共享附加作用与非共享附加作用的区别？",
                                                             targetVC: DriveViewController.self))
            
            let bo = RootCellViewModel(model: RootModel(title: "05: RxSwift观察者AnyObserver、Binder的使用",
                                                             targetVC: BinderObserverViewController.self))
            
            let mf = RootCellViewModel(model: RootModel(title: "06: RxSwift操作符操作符map、flatMap、flatMapLatest、filter的使用与区别",
                                                             targetVC: MapFilterViewController.self))
            
            let mzc = RootCellViewModel(model: RootModel(title: "07: RxSwift操作符merge、zip、combinLatest的使用",
                                                             targetVC: MZCViewController.self))
            
            let tsm = RootCellViewModel(model: RootModel(title: "08: RxSwift操作符take、skip、materialize、withLatestFrom、interval等的使用",
                                                             targetVC: TakeSkipAndMoreViewController.self))
            
            let schedulers = RootCellViewModel(model: RootModel(title: "09: RxSwift调度器 - Schedulers",
                                                             targetVC: SchedulersViewController.self))
            
            
            let doubleBind = RootCellViewModel(model: RootModel(title: "10: RxSwift-双向绑定",
                                                             targetVC: DoubleBindViewController.self))
            
            
            let mvvm01 = RootCellViewModel(model: RootModel(title: "11: RxSwift+MVVM项目实战-MVVM架构介绍以及实战初体验",
                                                             targetVC: AttentionViewController.self))
            
            let mvvm02 = RootCellViewModel(model: RootModel(title: "12: RxSwift+MVVM项目实战-登录功能实现",
                                                             targetVC: LoginViewController.self))
            
            let mvvm03 = RootCellViewModel(model: RootModel(title: "13: RxSwift+MVVM项目实战-单分组UITableView的使用",
                                                             targetVC: RootViewController.self))
            
            return [mvvm03,
                    mvvm02,
                    mvvm01,
                    doubleBind,
                    schedulers,
                    tsm,
                    mzc,
                    mf,
                    bo,
                    traits2,
                    traits1]
        }
    }
}
