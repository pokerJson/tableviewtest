//
//  TableViewCell.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/6.
//

import UIKit
import YYKit
import SnapKit

class TableViewCell: UITableViewCell {
    private var imageArr: [String]?

    lazy var headerImageV: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    lazy var contenL: YYLabel = {
        let la = YYLabel()
        la.numberOfLines = 3
        la.font = UIFont.systemFont(ofSize: 15)
        la.textAlignment = .left
        la.textColor = .red
        return la
    }()
    lazy var coll: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(kScreen_width - 52) / 3, height: (kScreen_width - 52) / 3)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.delegate = self
        col.dataSource = self
        col.register(myCell.self, forCellWithReuseIdentifier: "cc")
        return col
    }()
    lazy var line: UIView = {
        let la = UIView()
        la.backgroundColor = .orange
        return la
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerImageV)
        contentView.addSubview(contenL)
        contentView.addSubview(coll)
        contentView.addSubview(line)
        headerImageV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        contenL.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerImageV.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(10)
        }
        coll.snp.makeConstraints { (make) in
            make.top.equalTo(self.contenL.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(10)
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.coll.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(10)
        }

    }
    func fillData(model: OKModel)  {
        headerImageV.image = UIImage(named: "1")
        contenL.displaysAsynchronously = true
        contenL.textLayout = model.textLayout
        contenL.size = model.textLayout!.textBoundingSize
        contenL.lineBreakMode = .byTruncatingTail
        contenL.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat((model.textLayout?.textBoundingSize.height)!))
        }
        var height: CGFloat = 0
        if let str = model.imgs,str.isEmpty == false {
            let imageArr1 = str.components(separatedBy: ",")
            imageArr = imageArr1
            let count = imageArr1.count
            let culom:Int = Int((ceil(CGFloat(CGFloat(count) / 3))))
            let hei1:CGFloat = CGFloat(culom) * ((kScreen_width) - 52) / 3
            let hei2:CGFloat =  CGFloat((culom - 1) * 10)
            height = hei1 + hei2
            coll.reloadData()
            coll.isHidden = false
            coll.snp.updateConstraints { (make) in
                make.height.equalTo(height)
            }
        }else{
            coll.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
            coll.isHidden = true
        }

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cc", for: indexPath) as! myCell
            
        cell.fillData(str: (imageArr?[indexPath.row])!)
        return cell
    }
    
    
}
