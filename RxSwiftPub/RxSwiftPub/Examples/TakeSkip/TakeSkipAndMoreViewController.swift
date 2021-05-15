//
//  TakeSkipAndMoreViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class TakeSkipAndMoreViewController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        test_of_from_just()
//        testTake()
//        testTakeWhile()
//        testTakeUntil()
//        testSkip()
//        testSkipWhile()
//        testSkipUntil()
//        testMaterialize()
//        testWithLatestFromResultSelector()
//        testWithLatestFrom()
//        testTimer()
//        testInterval()
    }
    
    deinit {
        Logger("TakeSkipAndMoreViewController deinit")
    }
}

extension TakeSkipAndMoreViewController {
 
    func test_of_from_just() {
//        Observable.of(1)
//        Observable.of(1, 2, 3, 4)
//
//        Observable.just(1)
//
//        Observable.from([1])
//        Observable.from([1, 2, 3, 4])
    }
    
    func testTake() {
        let observable = Observable.of(1, 3, 5, 7)
        observable.take(2).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testTakeWhile() {
        let observable = Observable.of(7, 3, 2, 1)
        observable.take(while: { $0 > 2 }).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testTakeUntil() {
        let observable = Observable.of(1, 3, 5, 7)
        observable.take(until: { $0 > 3}).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testSkip() {
        let observable = Observable.of(1, 3, 5, 7)
        observable.skip(2).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testSkipWhile() {
        let observable = Observable.of(7, 5, 1, 3)
        observable.skip(while: { $0 > 3 }).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testSkipUntil() {
        let source = PublishSubject<Int>()
        let refSource = PublishSubject<Int>()
        source.skip(until: refSource).subscribe(onNext: { (value) in
            Logger(value)
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
        source.onNext(1)
        source.onNext(2)
        refSource.onNext(3)
        source.onNext(4)
        source.onNext(5)
    }
    
    
    func testMaterialize() {
        let observable = Observable.of(1, 3, 5, 7)
        observable.materialize().subscribe(onNext: { (event) in
            //正常情况下这里应该是一个值，使用materialize后这里都转换为了Event
            switch event {
            case .next(let value):
                Logger(value)
                break
            case .completed:
                Logger("completed")
                break
            default:
                Logger("defalut value")
            }
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testTimer() {
        let relay = Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
        relay.subscribe(onNext: { (value) in
            Logger("\(value) - \(Thread.current)")
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testInterval() {
        let relay = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        relay.subscribe(onNext: { (value) in
            Logger("\(value) - \(Thread.current)")
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
    }
    
    func testWithLatestFrom() {
        let source = PublishSubject<Int>()
        let refSource = PublishSubject<Int>()
        source.withLatestFrom(refSource).subscribe(onNext: { (value) in
            Logger("\(value)")
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
        source.onNext(1)
        source.onNext(2)
        refSource.onNext(3)
        refSource.onNext(4)
        source.onNext(5)
        source.onNext(6)
    }
    
    func testWithLatestFromResultSelector() {
        let source = PublishSubject<Int>()
        let refSource = PublishSubject<Int>()
        source.withLatestFrom(refSource) { (first, second) -> Int in
            return first + second
        }.subscribe(onNext: { (value) in
            Logger("\(value)")
        }, onCompleted: {
            Logger("onCompleted end")
        }).disposed(by: disposeBag)
        source.onNext(1)
        source.onNext(2)
        refSource.onNext(3)
        refSource.onNext(4)
        source.onNext(5)
        source.onNext(6)
    }
}
