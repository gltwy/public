//
//  BinderObserverViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/24.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class BinderObserverViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private lazy var label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 200, width: 200, height: 50))
        label.backgroundColor = .gray
        label.tintColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        anyObserver()
//        bindObserver()
//        bindError()
    }
    
    deinit {
        Logger("BinderObserverViewController deinit")
    }
}

extension BinderObserverViewController {
    
    enum TestError: Error {
        case none
    }
    
    func anyObserver() {
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        let observer = AnyObserver<String> {[weak self] (value) in
            if case .next(let text) = value {
                self?.label.text = text
            }
        }
        observable.map({ "倒计时: \($0)" }).bind(to: observer).disposed(by: disposeBag)
    }
    
    func bindError() {
        let binder = Binder<String>(label) { (label, text) in
            label.text = text
        }
        let observable = Observable<Int>.create { (observer) -> Disposable in
            observer.onError(TestError.none)
            return Disposables.create()
        }
        observable.map({ "倒计时: \($0)" }).bind(to: binder).disposed(by: disposeBag)
    }
    
    func bindObserver() {
        let binder = Binder<String>(label) { (label, text) in
            label.text = text
        }
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        observable.map({ "倒计时: \($0)" }).bind(to: binder).disposed(by: disposeBag)
        observable.map({ $0 % 2 == 0 ? .blue : .red }).bind(to: label.binderColor).disposed(by: disposeBag)
        observable.map({ .systemFont(ofSize: $0 % 2 == 0 ? 15 : 20) }).bind(to: label.rx.binderFont).disposed(by: disposeBag)
    }
}

extension UILabel {
    var binderColor: Binder<UIColor> {
        Binder<UIColor>(self) { (label, textColor) in
            label.textColor = textColor
        }
    }
}

extension Reactive where Base == UILabel {
    var binderFont: Binder<UIFont> {
        Binder<UIFont>(self.base) { (label, font) in
            label.font = font
        }
    }
}
