//
//  EditViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController {
    
    private lazy var tableView = loadTableView()
    private let viewModel = EditViewModel()
    private let disposeBag = DisposeBag()
    private let cellId = NSStringFromClass(EditViewController.self)
    private lazy var addItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "添加"
        item.tintColor = .red
        return item
    }()
    
    private lazy var editItem: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.tintColor = .blue
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindToViewModel()
    }
    
    deinit {
        Logger("RootViewController - deinit")
    }
}

//MARK: bind
extension EditViewController {
    
    private func bindToViewModel() {
                
        let output = viewModel.transform(input: EditViewModel.Input(refresh: Observable.of(()), moved: tableView.rx.itemMoved, delete: tableView.rx.itemDeleted, add: addItem.rx.tap.asObservable()))
                
        output.items.asDriver().drive(tableView.rx.items(cellIdentifier: cellId, cellType: EditTableViewCell.self)) {row, viewModel, cell in
            cell.bind(to: viewModel)
        }.disposed(by: disposeBag)
                
        tableView.rx.modelSelected(EditCellViewModel.self).subscribe {[weak self] (cellModel) in
            Logger(cellModel.element?.title.value)
            self?.navigationController?.pushViewController(EditViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {[weak tableView] in tableView?.deselectRow(at: $0, animated: true) }.disposed(by: disposeBag)
        
        editItem.rx.tap.map({[unowned self] in !self.tableView.isEditing }).bind(to: tableView.rx.isCanEditing).disposed(by: disposeBag)
        
        Observable.of(Observable.just(()), editItem.rx.tap.asObservable()).merge().map({[unowned self] _ in !self.tableView.isEditing }).bind(to: editItem.rx.isCanEditing).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension EditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
}

//MARK: 初始化相关
extension EditViewController {
    
    private func setupLayout() {
        self.title = "微信公众号-技术大咖社"
        view.backgroundColor = .white
        edgesForExtendedLayout = .bottom
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 16)]
        navigationItem.rightBarButtonItems = [addItem, editItem]
        view.addSubview(tableView)
    }
    
    private func loadTableView() -> UITableView {
        let navcH = UIApplication.shared.statusBarFrame.size.height + 44
        var height = view.frame.size.height - navcH
        if #available(iOS 11.0, *) {
            height -= UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: height), style: .grouped)
        tableView.estimatedRowHeight = 1.01
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 1.01
        tableView.estimatedSectionHeaderHeight = 1.01
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(EditTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }
}

extension Reactive where Base == UITableView {
    var isCanEditing: Binder<Bool> {
        Binder.init(self.base) { (tableView, editing) in
            tableView.setEditing(editing, animated: true)
        }
    }
}

extension Reactive where Base == UIBarButtonItem {
    var isCanEditing: Binder<Bool> {
        Binder.init(self.base) { (item, isEditing) in
            if isEditing {
                self.base.title = "开始编辑"
            }else {
                self.base.title = "停止编辑"
            }
        }
    }
}
