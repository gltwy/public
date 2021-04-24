//
//  SMCViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class SMCViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        singleObservable()
//        completableObservable()
        maybeObservable()
    }
    
    deinit {
        Logger("SMCViewController - deinit")
    }
}

extension SMCViewController {
    
    enum TestError: Error {
        case none
    }
    
    func singleObservable() {
        Single<Int>.create { (single) -> Disposable in
            single(.success(100))
            //    single(.failure(TestError.none))
            return Disposables.create()
        }.subscribe { (value) in
            Logger(value)
        } onFailure: { (error) in
            Logger(error)
        } onDisposed: {
            Logger("onDisposed")
        }.disposed(by: disposeBag)
    }
    
    func completableObservable() {
        Completable.create(subscribe: { (completable) -> Disposable in
            completable(.completed)
            completable(.error(TestError.none))
            return Disposables.create()
        }).subscribe {
            Logger("completed")
        } onError: { (error) in
            Logger(error)
        } onDisposed: {
            Logger("onDisposed")
        }.disposed(by: disposeBag)
    }
    
    func maybeObservable() {
        Maybe<Int>.create(subscribe: { (maybe) -> Disposable in
            maybe(.success(200))
            // maybe(.completed)
            // maybe(.error(TestError.none))
            return Disposables.create()
        }).subscribe { (element) in
            Logger(element)
        } onError: { (error) in
            Logger(error)
        } onCompleted: {
            Logger("completed")
        } onDisposed: {
            Logger("onDisposed")
        }.disposed(by: disposeBag)
    }
}

func Logger<T>(_ msg: T) {
    print("Log - \(msg)")
}
