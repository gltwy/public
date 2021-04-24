//
//  MapFilterViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/24.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class MapFilterViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        testMap()
//        testFlatMap()
//        testflatMapLatest()
        testFilter()
    }
    
    deinit {
        Logger("MapFilterViewController deinit")
    }
}


extension MapFilterViewController {

    func testMap() {
        let observable = Observable.of(1, 2, 3)
        let newObservable = observable.map { (value) -> Int in return value * 10 }
        newObservable.subscribe { (res) in
            Logger(res)
        }.disposed(by: disposeBag)
    }
    
    func testFlatMap() {
        let observable = BehaviorSubject<Int?>(value: 1)
        let parentObservable = BehaviorRelay<BehaviorSubject<Int?>>(value: observable)
        let newObservable = parentObservable.asObservable().flatMap { value -> BehaviorSubject<Int?> in
            return value
        }
        newObservable.subscribe { (res) in
            Logger(res)
        }.disposed(by: disposeBag)
        
        Logger("flatMap - ended - 以下代码为演示flatMapLatest做对比")
        let observable2 = BehaviorSubject<Int?>(value: 2)
        parentObservable.accept(observable2)
        observable.onNext(3)
    }
    
    func testflatMapLatest() {
        let observable = BehaviorSubject<Int?>(value: 1)
        let parentObservable = BehaviorRelay<BehaviorSubject<Int?>>(value: observable)
        let newObservable = parentObservable.asObservable().flatMapLatest { value -> BehaviorSubject<Int?> in
            return value
        }
        newObservable.subscribe { (res) in
            Logger(res)
        }.disposed(by: disposeBag)
        
        let observable2 = BehaviorSubject<Int?>(value: 2)
        parentObservable.accept(observable2)
        observable.onNext(3)
    }
    
    func testFilter() {
        let observable = Observable.of(1, 2, 3)
        let newObservable = observable.filter { (value) -> Bool in return value % 2 == 0 }
        
        newObservable.subscribe { (res) in
            Logger(res)
        }.disposed(by: disposeBag)
    }
}

