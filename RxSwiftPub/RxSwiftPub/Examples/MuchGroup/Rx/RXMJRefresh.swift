//
//  RXMJRefresh.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import MJRefresh
import RxCocoa

typealias RefreshEvent = () -> Void

//避免因局部创建的时候，使用之后就释放，这里要手动控制他的释放时机
class LTTarget: NSObject, Disposable {
    private var retainSelf: LTTarget?
    override init() {
        super.init()
        self.retainSelf = self
    }
    func dispose() {
        self.retainSelf = nil
    }
    deinit {
        Logger("LTTarget deinit")
    }
}

//继承LTTarget，避免因局部创建的时候，使用之后就释放，这里要手动控制他的释放时机
final class RefreshTarget<Element: MJRefreshComponent>: LTTarget {
 
    private var element: Element //MJRefreshComponent
    private var event: RefreshEvent //刷新事件
    
    init(_ element: Element, event: @escaping RefreshEvent) {
        self.element = element
        self.event = event
        super.init()
        //监听事件
        element.setRefreshingTarget(self, refreshingAction: #selector(startRefresh))
    }
    
    @objc private func startRefresh() {
        self.event() //回调给外界
    }
    
    deinit {
        Logger("RefreshTarget deinit")
    }
}

extension Reactive where Base: MJRefreshComponent {
    var glt_refreshing: ControlEvent<Void> {
        let observable = Observable<Void>.create {[weak comp = self.base] (observer) -> Disposable in
            //保证在主线程执行 否则抛出异常
            MainScheduler.ensureExecutingOnScheduler()
            guard let _comp = comp else {
                observer.on(.completed)
                return Disposables.create()
            }
            //用于处理监听MJRefresh的正在刷新事件，RefreshTarget释放时机跟随引用着glt_refreshing的变量一起
            let disposeable = RefreshTarget(_comp) {
                observer.onNext(())
            }
            return disposeable
        }.take(until: deallocated)
        return ControlEvent(events: observable)
    }
}

extension Reactive where Base: MJRefreshComponent {
    var glt_block_refreshing: ControlEvent<Void> {
        let observable = Observable<Void>.create {[weak comp = self.base] (observer) -> Disposable in
            //保证在主线程执行 否则抛出异常
            MainScheduler.ensureExecutingOnScheduler()
            guard let _comp = comp else {
                observer.on(.completed)
                return Disposables.create()
            }
            //用于处理监听MJRefresh的正在刷新事件，RefreshTarget释放时机跟随引用着glt_refreshing的变量一起
            _comp.refreshingBlock = {
                observer.onNext(())
            }
            return Disposables.create()
        }.take(until: deallocated)
        return ControlEvent(events: observable)
    }
}



enum LTRefreshEndState {
    case endRefreshing
    case noMoreData
}

extension Reactive where Base: UIScrollView {
    //用于外界刷新绑定、内部判断是是否有更多数据的UI状态
    var endRefreshing: Binder<LTRefreshEndState> {
        Binder<LTRefreshEndState>(self.base) { scrollView, state in
            scrollView.mj_header?.endRefreshing()
            if state == .noMoreData {
                scrollView.mj_footer?.endRefreshingWithNoMoreData()
            }else {
                scrollView.mj_footer?.endRefreshing()
            }
        }
    }
}


            
