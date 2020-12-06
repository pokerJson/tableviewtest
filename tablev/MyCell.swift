//
//  MyCell.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/6.
//

import UIKit
import YYKit

class MyCell: UITableViewCell {
    private var imageArr: [String]?

    @IBOutlet weak var contentLavel: YYLabel!
    @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentLavel.displaysAsynchronously = true
        contentLavel.preferredMaxLayoutWidth = kScreen_width - 32
        layout.itemSize = CGSize(width: (kScreen_width - 52) / 3, height: (kScreen_width - 52) / 3)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10
        coll.delegate = self
        coll.dataSource = self
        coll.register(myCell.self, forCellWithReuseIdentifier: "ce")    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(model: OKModel) {
//        contentLavel?.text = model.content
        contentLavel.size = model.textLayout!.textBoundingSize
        contentLavel.displaysAsynchronously = true
        contentLavel.textLayout = model.textLayout
        contentLavel.lineBreakMode = .byTruncatingTail
        imageArr = model.imgs?.components(separatedBy: ",")
        if let str = model.imgs,str.isEmpty == false {
            let imageArr = str.components(separatedBy: ",")
            let count = imageArr.count
            let culom:Int = Int((ceil(CGFloat(CGFloat(count) / 3))))
            let hei1:CGFloat = CGFloat(culom) * ((kScreen_width) - 52) / 3
            let hei2:CGFloat =  CGFloat((culom - 1) * 10)
            coll?.heightAnchor.constraint(equalToConstant: hei1 + hei2).isActive = true
            coll?.isHidden = false
        }else{
//            collectV.heightAnchor.constraint(equalToConstant:0).isActive = true
            coll?.isHidden = true
        }

        coll?.reloadData()
    }

}
extension MyCell : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ce", for: indexPath) as! myCell
        cell.fillData(str: imageArr![indexPath.row])
        return cell
    }

}
