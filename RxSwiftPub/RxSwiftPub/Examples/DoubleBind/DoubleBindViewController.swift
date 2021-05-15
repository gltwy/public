//
//  DoubleBindViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/15.
//

import UIKit
import RxSwift
import RxCocoa

class DoubleBindViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel = ViewModel()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
        textField.borderStyle = .line
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 200, width: 200, height: 50))
        label.backgroundColor = .darkGray
        label.tintColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(label)
        //        test()
        testBind()
    }
    
    deinit {
        Logger("DoubleBindViewController deinit")
    }
}

extension DoubleBindViewController {
    
    struct ViewModel {
        let phoneNumber = BehaviorRelay<String?>(value: nil)
    }
    
    //    在我们的实际开发中，在MVVM模式下，多数场景是，我们把ViewModel绑定到UI控件上，当ViewModel发生变化时，控件也跟着改变，而有些时候我们要同时实现当我们改变控件值时，ViewModel也跟着变化，这个时候就需要双向绑定，接下来我们就逐步实现一下双向绑定；
    
    func test() {
        //当phoneNumber变化的时候textField的text文本跟着变化
        viewModel.phoneNumber.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
        
        //当textField的text文本变化的时候phoneNumber跟着变化
        textField.rx.text.asObservable().bind(to: viewModel.phoneNumber).disposed(by: disposeBag)
        
        //以上两者为相互进行绑定
        //最后监听当phoneNumber变化的时候label的text文本跟着变化，目的仅为了在UI层展示
        viewModel.phoneNumber.asObservable().bind(to: label.rx.text).disposed(by: disposeBag)
    }
    
    func testBind() {
        
        //实现了textField的text和phoneNumber的相互绑定
        let _ = textField.rx.text <---> viewModel.phoneNumber
        
        //当phoneNumber变化的时候label的text文本跟着变化，目的仅为了在UI层展示
        viewModel.phoneNumber.asObservable().bind(to: label.rx.text).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.phoneNumber.accept("使用我的值")
    }
}

infix operator <---> : DefaultPrecedence
func <--->(property: ControlProperty<String?>, relay: BehaviorRelay<String?>) -> Disposable {
    let disposable = relay.bind(to: property)
    let disposable2 = property.asObservable().bind(to: relay)
    return Disposables.create(disposable, disposable2)
}


