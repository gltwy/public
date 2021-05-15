//
//  LoginViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa

typealias PhonePwd = (phone: String, pwd: String)

struct LoginViewModel {
    
    let localPhoneNumber: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    struct Input {
        let phone: ControlProperty<String?>
        let pwd: ControlProperty<String?>
        let login: ControlEvent<Void>
    }
    
    struct Output {
        let phoneValid: Driver<Bool>
        let phoneLimit: Observable<String>
        let pwdValid: Driver<Bool>
        let loginEnabled: Driver<Bool>
        let loginResult: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        
        localPhoneNumber.accept("1234567890") //获取默认手机号
        
        let _phone = input.phone.orEmpty.throttle(.milliseconds(100), scheduler: MainScheduler.instance).flatMap { (text) -> Observable<String> in
            if text.count > 11 {
                return Observable.just(String(text.prefix(11)))
            }
            return Observable.just(text)
        }
        let _pwd = input.pwd.orEmpty.throttle(.milliseconds(100), scheduler: MainScheduler.instance)

        let phoneValid = _phone.flatMap { (text) -> Observable<Bool> in
            return Observable.just(text.count == 11)
        }.asDriver(onErrorJustReturn: false)
  
        let pwdValid = _pwd.flatMap { (text) -> Observable<Bool> in
            return Observable.just(text.count > 5)
        }.asDriver(onErrorJustReturn: false)

        let loginEnabled = SharedSequence.combineLatest(phoneValid, pwdValid, loading.asDriver()).flatMap { (phone, pwd, isLoading) -> SharedSequence<DriverSharingStrategy, Bool> in
            return SharedSequence<DriverSharingStrategy, Bool>.just(phone && pwd && !isLoading)
        }
        
        let _result = Observable.combineLatest(_phone, _pwd).flatMap { (phone, pwd) -> Observable<PhonePwd> in
            return Observable.just((phone, pwd))
        }
        
        let loginResult = input.login.withLatestFrom(_result).flatMapLatest { self.request($0, $1) }.observe(on: MainScheduler.instance)
        
        return Output(phoneValid: phoneValid,
                      phoneLimit: _phone,
                      pwdValid: pwdValid,
                      loginEnabled: loginEnabled,
                      loginResult: loginResult)
    }
    
    private func request(_ phone: String, _ pwd: String) -> Observable<Bool> {
        Observable<Bool>.create { (observer) -> Disposable in
            Logger("发起请求 Loading... \(Thread.current)")
            self.loading.accept(true)
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                Logger("收到响应 End Loading... \(Thread.current)")
                self.loading.accept(false)
                if phone == "12345678901" && pwd == "123456" {
                    observer.onNext(true)
                }else {
                    observer.onNext(false)
                }
            }
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
}

