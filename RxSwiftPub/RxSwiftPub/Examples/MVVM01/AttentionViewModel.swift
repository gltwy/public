//
//  AttentionViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa

struct AttentionViewModel {
    
    //false代表未关注 true已关注
    private var attention = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let attention: ControlEvent<Void>
    }
    
    struct Output {
        let attentionStatus: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let initAction = requestInit()//请求初始数据
        
        let attentionAction = input.attention.flatMap({ request(!attention.value)} ).observe(on: MainScheduler.instance).share(replay: 1) //关注、取消关注点击
        
        //合并结果-把按钮点击或者请求初始数据的时候都去更新关注按钮状态
        let attentionStatus = Observable.of(attentionAction, initAction).merge()
        
        return Output(attentionStatus: attentionStatus)
    }
    
    private func request(_ isAttention: Bool) -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            Logger("发起更新状态请求\nLoading...")
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                Logger("响应更新状态结果...isAttention = \(isAttention)")
                observer.onNext(isAttention)//是否关注
                self.attention.accept(isAttention)// 关注或取消关注成功、存储状态
            })
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
    
    private func requestInit() -> Observable<Bool> {
        return Observable<Bool>.create { (observer) -> Disposable in
            Logger("正在请求初始状态\nLoading...")
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
                let model = AttentionModel()//模拟将请求结果转换为Model...
                model.isAttention = true //假设默认状态为已关注
                Logger("初始状态响应结果...isAttention = \(model.isAttention) \n")
                
                //Event处理...
                observer.onNext(model.isAttention)//用于通知View去更新关注状态
                attention.accept(model.isAttention)//存储关注的状态
            })
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
}
