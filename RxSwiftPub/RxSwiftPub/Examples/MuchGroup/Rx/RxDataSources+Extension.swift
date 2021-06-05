//
//  RxDataSources+Extension.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/6/5.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class LTTableViewSectionedReloadDataSource<Section: SectionModelType> : RxTableViewSectionedReloadDataSource<Section> {

    let reloadEnded = PublishRelay<Void>()
    
    override func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        super.tableView(tableView, observedEvent: observedEvent)
        reloadEnded.accept(())
    }
}


class LTCollectionSectionedReloadDataSource<Section: SectionModelType> : RxCollectionViewSectionedReloadDataSource<Section> {

    let reloadEnded = PublishRelay<Void>()
    
    override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        super.collectionView(collectionView, observedEvent: observedEvent)
        reloadEnded.accept(())
    }
}
