//
//  MZCViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/24.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class MZCViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        merge()
//        zip()
//        combineLatest()
    }
    
    deinit {
        Logger("DriveViewController deinit")
    }
}

extension MZCViewController {
    
    enum TestError: Error {
        case none
    }
    
    func merge() {
        let publishSubject1 = PublishSubject<String>()
        let publishSubject2 = PublishSubject<String>()
        Observable.of(publishSubject1, publishSubject2).merge().subscribe { (ele) in
            Logger(ele)
        } onError: { (error) in
            Logger("error - \(error)")
        } onCompleted: {
            Logger("oncompleted")
        } onDisposed: {
            
        }.disposed(by: self.disposeBag)
        
        publishSubject1.onNext("1")
        publishSubject1.onNext("2")
        publishSubject2.onNext("A")
        publishSubject1.onNext("3")
        publishSubject2.onNext("B")
        //        publishSubject1.onError(TestError.none)
        publishSubject1.onCompleted()
        publishSubject2.onNext("C")
        publishSubject2.onCompleted()
        publishSubject1.onNext("D")
        publishSubject2.onNext("E")
    }
    
    func zip() {
        let publishSubject1 = PublishSubject<String>()
        let publishSubject2 = PublishSubject<String>()
        Observable.zip(publishSubject1, publishSubject2).subscribe { (ele) in
            Logger("\(ele.0) - \(ele.1)")
        } onError: { (error) in
            Logger("error - \(error)")
        } onCompleted: {
            Logger("oncompleted")
        } onDisposed: {
            
        }.disposed(by: self.disposeBag)
        
        publishSubject1.onNext("1")
        publishSubject1.onNext("2")
        publishSubject2.onNext("A")
        //        publishSubject2.onCompleted()
        publishSubject1.onNext("3")
        publishSubject2.onNext("B")
        publishSubject1.onNext("4")
        //    publishSubject1.onError(TestError.none)
        //    publishSubject1.onCompleted()
        //    publishSubject2.onCompleted()
        publishSubject2.onNext("C")
        publishSubject1.onNext("4")
        publishSubject2.onNext("D")
    }
    
    func combineLatest() {
        let publishSubject1 = PublishSubject<String>()
        let publishSubject2 = PublishSubject<String>()
        Observable.combineLatest(publishSubject1, publishSubject2).subscribe { (ele) in
            Logger(ele)
        } onError: { (error) in
            Logger("error - \(error)")
        } onCompleted: {
            Logger("oncompleted")
        } onDisposed: {
            
        }.disposed(by: self.disposeBag)
        
        publishSubject1.onNext("1")
        //        publishSubject1.onError(TestError.none)
        publishSubject1.onNext("2")
        publishSubject2.onNext("A")
        publishSubject1.onNext("3")
        publishSubject2.onNext("B")
        publishSubject1.onNext("4")
        publishSubject2.onNext("C")
        publishSubject1.onNext("5")
    }
}

