//
//  MuchGroupViewModel.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import HandyJSON
import MJRefresh

class MuchGroupViewModel {
    
    private let disposeBag = DisposeBag()
    private lazy var pageNum = 0
    
    private enum RespEvent {
        case resp(_ data: [MuchGroupSection], _ state: LTRefreshEndState)
        var data: [MuchGroupSection] {
            switch self {
            case .resp(let data, _):
                return data
            }
        }
        var state: LTRefreshEndState {
            switch self {
            case .resp(_, let _state):
                return _state
            }
        }
    }
    
    struct Input {
        let refresh: Observable<Void>
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        let items: BehaviorRelay<[MuchGroupSection]>
        let endRefreshing: PublishRelay<LTRefreshEndState>
    }
    
    func transform(input: Input) -> Output {
    
        let items = BehaviorRelay<[MuchGroupSection]>(value: [])
        let endRefreshing = PublishRelay<LTRefreshEndState>()
        
        //下拉刷新数据，请求第0页的数据并转换为Observable<RespEvent>类型
        let header = Observable.of(input.refresh, input.headerRefresh).merge().flatMap {[unowned self] (v1) -> Observable<RespEvent> in
            self.pageNum = 0
            return self.request(pageNum: self.pageNum)
        }.share(replay: 1, scope: .whileConnected)
        
        //抛出给外界，用于绑定到tableView数据源
        header.map { $0.data }.bind(to: items).disposed(by: disposeBag)
        
        //拿到返回数据通知外界停止刷新
        header.map { $0.state }.bind(to: endRefreshing).disposed(by: disposeBag)

        //上拉加载更多数据，请求第1.2.3...页的数据并转换为Observable<RespEvent>类型
        let footer = input.footerRefresh.flatMap {[unowned self] (_) -> Observable<RespEvent> in
            self.pageNum += 1
            return self.request(pageNum: self.pageNum)
        }.share(replay: 1, scope: .whileConnected)
        
        //把当前页数据和前几页数据做拼接，并抛出给外界，用于绑定到tableView数据源
        footer.map { (event) -> [MuchGroupSection] in
            guard case .resp(let data, _) = event else { return items.value }
            return items.value + data
        }.bind(to: items).disposed(by: disposeBag)
        
        //拿到返回数据通知外界停止刷新
        footer.map { $0.state }.bind(to: endRefreshing).disposed(by: disposeBag)

        return Output(items: items, endRefreshing: endRefreshing)
    }
    
    private func request(pageNum: Int) -> Observable<RespEvent> {
        let url = URL(string: "https://geoapi.qweather.com/v2/city/lookup")!
        Logger("\(pageNum == 0 ? "下拉刷新" : "上拉加载")发起请求...")
        return RxAlamofire.requestJSON(.get, url)
            .map { _ in MuchGroupModel.json }
            .map(model: MuchGroupModel.self)
            .map ({ (model) -> RespEvent in
                Logger("收到请求结果...")
                var section = [MuchGroupSection]()
                for item in model.data ?? [] {
                    var liveSections = [MuchGroupSectionItem]()
                    var bannerSections = [MuchGroupSectionItem]()
                    if item.type == 1 {
                        let bannerCellViewModel = MuchGroupBannerViewModel(model: item)
                        let bannerItem = MuchGroupSectionItem.banner(cellViewModel: bannerCellViewModel)
                        bannerSections.append(bannerItem)
                        if pageNum == 0 {
                            let banner = MuchGroupSection.banner(title: "bannerCell", items: bannerSections)
                            section.append(banner)
                        }
                    }else {
                        let liveCellViewModel = MuchGroupLiveViewModel(model: item)
                        let liveItem = MuchGroupSectionItem.live(cellViewModel: liveCellViewModel)
                        liveSections.append(liveItem)
                        let live = MuchGroupSection.banner(title: "bannerCell", items: liveSections)
                        section.append(live)
                    }
                }
                if pageNum > 1  {
                    return RespEvent.resp(section, .noMoreData)
                }else {
                    return RespEvent.resp(section, .endRefreshing)
                }
            })
    }
}

extension Observable where Element == [String : Any] {
    func map<T: HandyJSON>(model: T.Type) -> Observable<T> {
        self.map { (element) -> T in
            guard let ret = T.deserialize(from: element) else { fatalError("数据格式不正确") /** 此处自行处理 */ }
            return ret
        }
    }
}



