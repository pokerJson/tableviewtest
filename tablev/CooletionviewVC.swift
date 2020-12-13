//
//  CooletionviewVC.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/13.
//

import UIKit

class CooletionviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qq", for: indexPath) as! MyColleViewCell
        cell.fillData(str: listArr![indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidth(str: listArr![indexPath.row]) + 20, height: 30)
    }
    private var listArr: [String]?
    lazy var coll: UICollectionView = {
        let lay = Mylayout()
        lay.minimumLineSpacing = 20
        lay.minimumInteritemSpacing = 20
        lay.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        lay.scrollDirection = .vertical
        let re = UICollectionView(frame: .zero, collectionViewLayout: lay)
        re.delegate = self
        re.dataSource = self
        re.register(MyColleViewCell.self, forCellWithReuseIdentifier: "qq")
        return re
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(coll)
        coll.backgroundColor = .white
        coll.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        listArr = ["是打发斯蒂芬dafsad发送到发阿斯蒂芬","都阿士大夫撒旦发是"]
    }
    
    private func getWidth(str: String) -> CGFloat {
        return str.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context:nil).size.width;
     }


}
class MyColleViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let re = UILabel()
        re.font = UIFont.systemFont(ofSize: 15)
        re.backgroundColor = .gray
        re.layer.cornerRadius = 15
        re.layer.masksToBounds = true
        re.textAlignment = .center
        return re
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func fillData(str: String) {
        titleLabel.text = str
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
