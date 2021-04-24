//
//  RootViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/4/17.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: UIViewController {
    
    private lazy var tableView = loadTableView()
    private let viewModel = RootViewModel()
    private let disposeBag = DisposeBag()
    private let cellId = NSStringFromClass(RootViewController.self)

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
extension RootViewController {
    
    private func bindToViewModel() {
        let output = viewModel.transform(input: RootViewModel.Input(refresh: Observable.just(())))
        output.items.asDriver().drive(tableView.rx.items(cellIdentifier: cellId, cellType: RootTableViewCell.self)) {row, viewModel, cell in
            cell.bind(to: viewModel)
        }.disposed(by: disposeBag)
                
        tableView.rx.modelSelected(RootCellViewModel.self).subscribe {[weak self] (cellModel) in
            if let targetVC = cellModel.element?.targetVC.value {
                self?.navigationController?.pushViewController(targetVC.init(), animated: true)
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {[weak tableView] in tableView?.deselectRow(at: $0, animated: true) }.disposed(by: disposeBag)
    }
}

//MARK: 初始化相关
extension RootViewController {
    
    private func setupLayout() {
        self.title = "RxSwift相关-公众号：技术大咖社"
        view.backgroundColor = .white
        edgesForExtendedLayout = .bottom
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 16)]
        view.addSubview(tableView)
    }
    
    private func loadTableView() -> UITableView {
        let tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.estimatedRowHeight = 1.01
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 1.01
        tableView.estimatedSectionHeaderHeight = 1.01
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(RootTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }
}
