//
//  LoginView.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit

class LoginView: UIView {

    lazy var phoneTextFied: UITextField = {
        let phoneTextFied = UITextField()
        phoneTextFied.placeholder = "请输入手机号(11位)"
        phoneTextFied.borderStyle = .line
        phoneTextFied.keyboardType = .numberPad
        return phoneTextFied
    }()
    
    lazy var pwdTextFied: UITextField = {
        let pwdTextFied = UITextField()
        pwdTextFied.placeholder = "请输入密码(至少六位)"
        pwdTextFied.borderStyle = .line
        pwdTextFied.keyboardType = .numberPad
        return pwdTextFied
    }()
    
    lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitleColor(.white, for: .normal)
        return loginButton
    }()
    
    lazy var warnLabel: UILabel = {
        let warnLabel = UILabel()
        warnLabel.textColor = .red
        return warnLabel
    }()
    
override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(phoneTextFied)
    addSubview(pwdTextFied)
    addSubview(loginButton)
    addSubview(warnLabel)
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        _makeLayout()
        super.updateConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool { true }
}

extension LoginView {
    
    private func _makeLayout()  {
        
        phoneTextFied.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(120)
            make.height.equalTo(44)
        }
        
        pwdTextFied.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(phoneTextFied)
            make.top.equalTo(phoneTextFied.snp.bottom).offset(20)
        }
        
        warnLabel.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(phoneTextFied)
            make.top.equalTo(pwdTextFied.snp.bottom).offset(20)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(phoneTextFied)
            make.top.equalTo(warnLabel.snp.bottom).offset(20)
        }
    }
}

