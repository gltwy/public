//
//  MuchGroupViewController.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh

class MuchGroupViewController: UIViewController {
    
    private lazy var tableView = loadTableView()
    private let viewModel = MuchGroupViewModel()
    private let disposeBag = DisposeBag()
    private let cellId = NSStringFromClass(MuchGroupViewController.self)
    private lazy var refreshItem: UIBarButtonItem = {
        let refreshItem = UIBarButtonItem()
        refreshItem.title = "刷新"
        refreshItem.tintColor = .red
        return refreshItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindToViewModel()
    }
    
    deinit {
        Logger("MuchGroupViewController - deinit")
    }
}

//MARK: bind
extension MuchGroupViewController: MuchGroupCellRegister {
    
    private func bindToViewModel() {
        
        let output = viewModel.transform(input: MuchGroupViewModel.Input(refresh: Observable.just(()),
                                               headerRefresh: tableView.mj_header!.rx.glt_refreshing.asObservable(),
                                               footerRefresh: tableView.mj_footer!.rx.glt_refreshing.asObservable()))
                
        let dataSource = LTTableViewSectionedReloadDataSource<MuchGroupSection> {[unowned self] (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .banner(let viewModel):
                let cell: MuchGroupBannerCell = self.cellWithTableView(tableView)
                //绑定
                cell.bind(to: viewModel)
                //按钮点击事件
                cell.openSubjuect.subscribe {[weak self] (_) in
                    self?.openEvent(viewModel.model, indexPath)
                }.disposed(by: cell.disposeBag)
                return cell
            case .live(let viewModel):
                let cell: MuchGroupLiveCell = self.cellWithTableView(tableView)
                //绑定
                cell.bind(to: viewModel)
                //按钮点击事件
                cell.openSubjuect.subscribe {[weak self] (_) in
                    self?.openEvent(viewModel.model, indexPath)
                }.disposed(by: cell.disposeBag)
                return cell
            }
        }
        
        output.items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        output.endRefreshing.bind(to: tableView.rx.endRefreshing).disposed(by: disposeBag)
        
        dataSource.reloadEnded.subscribe { (_) in
            Logger("reloadData完毕")
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe {[weak self] (value) in
            if let indexPath = value.element {
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            self?.navigationController?.pushViewController(MuchGroupViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        refreshItem.rx.tap.subscribe {[weak self] (_) in
            self?.tableView.mj_header?.beginRefreshing()
        }.disposed(by: disposeBag)

        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension MuchGroupViewController {
    private func openEvent(_ model: MuchGroupListModel?, _ indexPath: IndexPath) {
        guard let model = model else { return }
        Logger("演示按钮事件 - \(model.type ?? -1) - \(model.name ?? "") - \(indexPath.section) - \(indexPath.row)")
        UIApplication.shared.open(URL(string: "weixinapp://pref")!, options: [:]) { (result) in
            Logger(result ? "打开微信成功" : "打开微信失败")
        }
    }
}

extension MuchGroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.0001
    }
}

//MARK: 初始化相关
extension MuchGroupViewController {
    
    private func setupLayout() {
        title = "微信公众号-技术大咖社"
        view.backgroundColor = .white
        edgesForExtendedLayout = .bottom
        navigationItem.rightBarButtonItem = refreshItem
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 16)]
        view.addSubview(tableView)
    }
    
    private func loadTableView() -> UITableView {
        let navcH = UIApplication.shared.statusBarFrame.size.height + 44
        var height = view.frame.size.height - navcH
        if #available(iOS 11.0, *) {
            height -= UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: height), style: .grouped)
        tableView.estimatedRowHeight = 1.001
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = 1.001
        tableView.estimatedSectionHeaderHeight = 1.001
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_footer = MJRefreshBackNormalFooter()
        tableView.register(RootTableViewCell.self, forCellReuseIdentifier: cellId)
        return tableView
    }
}
