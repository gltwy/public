//
//  DriveViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class DriveViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 50))
        textField.borderStyle = .line
        textField.keyboardType = .numberPad
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
//        testObservable()
//        testMainObservable()
//        testDriver()
    }
    
    deinit {
        Logger("DriveViewController deinit")
    }
}

extension DriveViewController {
    
    enum TestError: Error {
        case none
    }
    
    func testObservable() {
        
        let observable = textField.rx.text.skip(1).flatMap {[weak self] (text) -> Observable<String> in
            guard let `self` = self else { return Observable.just("") }//释放之后，如果还来到这self为空的时候发出一个空字符串信号
            // subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)) 在后台构建序列
            return self.dealwithData(inputText: text ?? "").subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        }
        
        observable.subscribe { (result) in
            Logger("第一次订阅 \(result) - 线程 - \(Thread.current)")
        }.disposed(by: disposeBag)

        observable.subscribe { (result) in
            Logger("第二次订阅 \(result) - 线程 - \(Thread.current)")
        }.disposed(by: disposeBag)
    }
    
    func testMainObservable() {
        
        let observable = textField.rx.text.skip(1).flatMap {[weak self] (text) -> Observable<String> in
            guard let `self` = self else { return Observable.just("") }
            // subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)) 在后台构建序列
            return self.dealwithData(inputText: text ?? "").subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        }.observe(on: MainScheduler.instance).share(replay: 1, scope: .whileConnected)
        
        observable.subscribe { (result) in
            Logger("第一次订阅 \(result) - 线程 - \(Thread.current)")
        } onError: { (error) in
            Logger(error)//.catchAndReturn("error")
        }.disposed(by: disposeBag)

        observable.subscribe { (result) in
            Logger("第二次订阅 \(result) - 线程 - \(Thread.current)")
        } onError: { (error) in
            Logger(error)
        }.disposed(by: disposeBag)
    }
    
//    3，subscribeOn 与 observeOn 区别
//    （1）subscribeOn()
//    该方法决定数据序列的构建函数在哪个 Scheduler 上运行。
//
//    （2）observeOn()
//    该方法决定在哪个 Scheduler 上监听这个数据序列。
    
    func testDriver() {
    
        let driver = textField.rx.text.asDriver().skip(1).flatMap {[weak self] (text) -> Driver<String> in
            guard let `self` = self else { return Observable.just("").asDriver(onErrorJustReturn: "drive error") }
            return self.dealwithData(inputText: text ?? "").asDriver(onErrorJustReturn: "drive error")
        }
        
        driver.drive { (result) in
            Logger("第一次订阅 \(result) - 线程 - \(Thread.current)")
        } onCompleted: {
            Logger("onCompleted")
        } onDisposed: {
            Logger("onDisposed")
        }.disposed(by: disposeBag)

        driver.drive { (result) in
            Logger("第二次订阅 \(result) - 线程 - \(Thread.current)")
        } onCompleted: {
            Logger("onCompleted")
        } onDisposed: {
            Logger("onDisposed")
        }.disposed(by: disposeBag)
    }
    
    func dealwithData(inputText: String)-> Observable<String>{
        return Observable<String>.create({ (observer) -> Disposable in
            Logger("开始模拟发起请求 当前线程 - \(Thread.current)") // 主线程
            if inputText == "123" {
                observer.onError(TestError.none)
                return Disposables.create()
            }
            observer.onNext("已经输入: \(inputText)")
            return Disposables.create()
        })
    }
    
    func test()  {
//        let observable = Observable.just(1)
//        observable.observe(on: MainScheduler.instance).catchAndReturn(-1).share(replay: 1, scope: .whileConnected)
//        //等价
//        observable.asDriver(onErrorJustReturn: -1)
    }
    
}
