//
//  EditTableViewCell.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//

import UIKit
import RxCocoa
import RxSwift

class EditTableViewCell: UITableViewCell {

    private lazy var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditTableViewCell {
    
    func bind(to viewModel: EditCellViewModel) {
        if let _label = textLabel {
            viewModel.title.bind(to: _label.rx.text).disposed(by: disposeBag)
        }
    }
}
