//
//  SchedulersViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa

class SchedulersViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //        testSche()
        testQueue()
    }
    
    deinit {
        Logger("SchedulersViewController deinit")
    }
}

extension SchedulersViewController {
    
    
    func testGCD() {
        DispatchQueue.global().async {
            //耗时操作代码
            DispatchQueue.main.async {
                //刷新UI
            }
        }
    }
    
    func loadData() -> Observable<Int> {
        Observable.create { (oberver) -> Disposable in
            Logger("\(Date()) - 发起请求 - \(Thread.current)")
            sleep(3)
            //...
            oberver.onNext(1)
            return Disposables.create()
        }
    }
    
    func testSche() {
        loadData().subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive)).observe(on: MainScheduler.instance).subscribe { (value) in
            Logger("\(Thread.current)")
        }.disposed(by: disposeBag)
    }
    
    func testQueue() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        loadData().subscribe(on: OperationQueueScheduler(operationQueue: queue)).observe(on: MainScheduler.instance).subscribe { (value) in
            Logger("\(Date()) - \(Thread.current)")
        }.disposed(by: disposeBag)
        
        loadData().subscribe(on: OperationQueueScheduler(operationQueue: queue)).observe(on: MainScheduler.instance).subscribe { (value) in
            Logger("\(Date()) - \(Thread.current)")
        }.disposed(by: disposeBag)
    }
}
