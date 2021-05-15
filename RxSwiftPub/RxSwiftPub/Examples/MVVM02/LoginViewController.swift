//
//  LoginViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    private lazy var loginView: LoginView = {
        return LoginView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loginView)
        loginView.snp.makeConstraints { $0.edges.equalTo(0)}
        bindToViewModel()
    }
    
    deinit {
        Logger("TestLoginViewController deinit")
    }
}


extension LoginViewController {
    
    private func bindToViewModel() {
        
        let output = viewModel.transform(input: LoginViewModel.Input(phone: loginView.phoneTextFied.rx.text, pwd: loginView.pwdTextFied.rx.text, login: loginView.loginButton.rx.tap))
        
        _ = loginView.phoneTextFied.rx.text <-> viewModel.localPhoneNumber//演示双向绑定
        
        output.phoneLimit.bind(to: loginView.phoneTextFied.rx.text).disposed(by: disposeBag)//演示bind
        
        output.phoneValid.drive(loginView.warnLabel.phoneWarnBinder).disposed(by: disposeBag)//演示driver
        
        output.pwdValid.drive(loginView.warnLabel.pwdWarnBinder).disposed(by: disposeBag)//演示给Label扩展Binder
        
        output.loginEnabled.drive(loginView.loginButton.rx.isEnabled).disposed(by: disposeBag)//演示给Rective的Button扩展Binder
        
        output.loginEnabled.drive(loginView.loginButton.rx.bindLoginBackground).disposed(by: disposeBag)//演示给Rective的Button扩展Binder
        
        viewModel.loading.asDriver().drive(loginView.loginButton.rx.loginLoadingTitle).disposed(by: disposeBag)//演示通过viewModel内的属性直接绑定
        
        output.loginResult.subscribe(onNext: { res in //演示登录/失败做其他操作
            if res {
                Logger("登录成功 - 跳转界面 - \(Thread.current)")
            }else {
                Logger("登录失败 - 请重新登录 - \(Thread.current)")
            }
        }).disposed(by: disposeBag)
    }
}

extension Reactive where Base == UIButton {
    
    fileprivate var bindLoginBackground: Binder<Bool> {
        Binder<Bool>(self.base) { (item, value) in
            if value {
                item.backgroundColor = .blue
            }else {
                item.backgroundColor = .gray
            }
        }
    }
    
    fileprivate var loginLoadingTitle: Binder<Bool> {
        Binder<Bool>(self.base) { (item, value) in
            if value {
                item.setTitle("正在登录...", for: .normal)
            }else {
                item.setTitle("登录", for: .normal)
            }
        }
    }
}

extension UILabel {
    fileprivate var phoneWarnBinder: Binder<Bool> {
        Binder(self) { (label, canUse) in
            if canUse {
                label.text = "手机号可用"
                label.textColor = .blue
            }else {
                label.text = "手机号格式不正确"
                label.textColor = .red
            }
        }
    }
    
    fileprivate var pwdWarnBinder: Binder<Bool> {
        Binder(self) { (label, canUse) in
            if canUse {
                label.text = "密码可用"
                label.textColor = .blue
            }else {
                label.text = "密码格式不正确"
                label.textColor = .red
            }
        }
    }
}



