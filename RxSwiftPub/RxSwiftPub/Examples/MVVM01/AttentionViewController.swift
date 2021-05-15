//
//  AttentionViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AttentionViewController: UIViewController {
    
    private let viewModel = AttentionViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var attentionButton: Button = {
        let button = Button(type: .custom)
        button.setTitle("关注", for: .normal)
        button.setTitle("取消关注", for: .selected)
        button.backgroundColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(attentionButton)
        _layout()
        bindToViewModel()
    }
}


extension AttentionViewController {
    
    private func bindToViewModel() {
        
        let output = viewModel.transform(input: AttentionViewModel.Input(attention: attentionButton.rx.tap))
        
        output.attentionStatus.bind(to: attentionButton.rx.isSelected).disposed(by: disposeBag)
    }
}

extension AttentionViewController {
    private func _layout() {
        attentionButton.snp.makeConstraints({
            $0.width.equalTo(200)
            $0.height.equalTo(45)
            $0.centerX.equalTo(self.view)
            $0.top.equalTo(150)
        })
    }
}

class Button: UIButton {
    override var isHighlighted: Bool {
        set {}
        get { false }
    }
}

