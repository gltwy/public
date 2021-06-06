//
//  MuchGroupBannerCell.swift
//  RxSwiftPub
//
//  Created by 高刘通 on 2021/5/30.
//  欢迎搜索并关注微信公众号：技术大咖社
//

import UIKit
import RxCocoa
import RxSwift

protocol MuchGroupCellRegister { }

extension MuchGroupCellRegister {
    func cellWithTableView<T: UITableViewCell>(_ tableView: UITableView) -> T {
        let identifier = NSStringFromClass(T.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = T(style: .default, reuseIdentifier: identifier)
        }
        return cell as! T
    }
}

class MuchGroupBannerCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    let openSubjuect = PublishSubject<Void>()
    
    private lazy var picImageView: UIImageView = {
        let picImageView = UIImageView()
        return picImageView
    }()
    
    private lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        return lineView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.font = .systemFont(ofSize: 14)
        nickNameLabel.textColor = .orange
        return nickNameLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12)
        detailLabel.textColor = .gray
        return detailLabel
    }()
    
    private lazy var openButton: UIButton = {
        let openButton = UIButton(type: .custom)
        openButton.setTitle("去关注", for: .normal)
        openButton.setTitleColor(.black, for: .normal)
        openButton.titleLabel?.font = .systemFont(ofSize: 13)
        openButton.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        return openButton
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: MuchGroupBannerViewModel) {
        viewModel.image.bind(to: picImageView.rx.image).disposed(by: disposeBag)
        viewModel.title.bind(to: nickNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.detail.bind(to: detailLabel.rx.text).disposed(by: disposeBag)
        openButton.rx.tap.bind(to: openSubjuect).disposed(by: disposeBag)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _appendSubViews()
        _layoutConstraints()
    }
    
    private func _appendSubViews() {
        contentView.addSubview(picImageView)
        contentView.addSubview(lineView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(openButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MuchGroupBannerCell {
    
    private func _layoutConstraints() {
        picImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
            make.width.height.equalTo(50)
            make.bottom.equalTo(-15).priority(666)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        openButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(65)
            make.height.equalTo(30)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(picImageView.snp.right).offset(5)
            make.right.equalTo(openButton.snp.left).offset(-5)
            make.top.equalTo(picImageView.snp.top)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nickNameLabel.snp.left)
            make.right.equalTo(nickNameLabel.snp.right)
            make.bottom.equalTo(picImageView.snp.bottom)
        }
    }
}


