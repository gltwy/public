//
//  EditViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxCocoa
import RxSwift

enum EditOperationType {
    case refresh //刷新
    case delete(items: IndexPath) //删除
    case move(event: ItemMovedEvent) //移动
    case add(cellModel: EditCellViewModel) //添加
}

class EditViewModel {

    private let disposeBag = DisposeBag()
    
    struct Input {
        let refresh: Observable<Void>
        let moved: ControlEvent<ItemMovedEvent>
        let delete: ControlEvent<IndexPath>
        let add: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[EditCellViewModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let dataSource = BehaviorRelay<[EditCellViewModel]>(value: [])
        
        let refresh = input.refresh.map({ EditOperationType.refresh })
        
        let delete = input.delete.map({ EditOperationType.delete(items: $0) })
        
        let move = input.moved.map({ EditOperationType.move(event: $0)})
        
        let add = input.add.map({ EditOperationType.add(cellModel: EditCellViewModel(model: EditModel(title: "添加标题"))) })

        Observable.of(refresh, delete, move, add).merge().map {[weak self] type -> [EditCellViewModel] in
            guard let `self` = self else { return [] }
            switch type {
            case .delete(let indexPath):
                self.dataSource.remove(at: indexPath.row)
                break
            case .move(let itemMove):
                self.dataSource.insert(self.dataSource.remove(at: itemMove.sourceIndex.row), at: itemMove.destinationIndex.row)
                break
            case .refresh:
                break
            case .add(cellModel: let cellModel):
                self.dataSource.append(cellModel)
                break
            }
            return self.dataSource
        }.bind(to: dataSource).disposed(by: disposeBag)
                
        return Output(items: dataSource)
    }
    
    private lazy var dataSource: [EditCellViewModel] = {
        var _items = [EditCellViewModel]()
        for index in 0...5 {
            let a1 = EditModel.random
            _items.append(EditCellViewModel(model: EditModel(title: "初始标题")))
        }
        return _items
    }()
    
    deinit {
        Logger("RootViewModel deinit")
    }
}
