//
//  HeaderView.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/5.
//

import UIKit
import YYKit

class HeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ce", for: indexPath) as! myCell
        cell.fillData(str: imageArr![indexPath.row])
        return cell
    }
    

    @IBOutlet weak var photoImaV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelIv: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var collectV: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    private var imageArr: [String]?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        layout.itemSize = CGSize(width: (kScreen_width - 52) / 3, height: (kScreen_width - 52) / 3)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10
        collectV.delegate = self
        collectV.dataSource = self
        collectV.register(myCell.self, forCellWithReuseIdentifier: "ce")
    }
    func fillData(model: OKModel) {
        contentLabel.text = model.content
        imageArr = model.imgs?.components(separatedBy: ",")
        if let str = model.imgs,str.isEmpty == false {
            let imageArr = str.components(separatedBy: ",")
            let count = imageArr.count
            let culom:Int = Int((ceil(CGFloat(CGFloat(count) / 3))))
            let hei1:CGFloat = CGFloat(culom) * ((kScreen_width) - 52) / 3
            let hei2:CGFloat =  CGFloat((culom - 1) * 10)
            collectV.heightAnchor.constraint(equalToConstant: hei1 + hei2).isActive = true
            collectV.isHidden = false
        }else{
//            collectV.heightAnchor.constraint(equalToConstant:0).isActive = true
            collectV.isHidden = true
        }

        collectV.reloadData()
    }
}
class OKModel: NSObject {
    var photo: String?
    var name: String?
    var content: String?
    var imgs: String?
    var textLayout: YYTextLayout? {
//        CGSize size = CGSizeMake(W-85, CGFLOAT_MAX);
//        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:self.commendcontent];
//        NSRange range = NSMakeRange(0, self.commendcontent.length);
//
//        [attString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]} range:range];
//        [attString addAttribute:NSForegroundColorAttributeName value:T333333 range:range];
//
//        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attString];
        let size = CGSize(width: kScreen_width - 32, height: CGFloat.greatestFiniteMagnitude)
        let attString = NSMutableAttributedString(string: self.content ?? "")
        let range = NSRange(location: 0, length: self.content?.count ?? 0)
        attString.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], range: range)
        attString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: range)
        

        let container = YYTextContainer(size: CGSize(width: kScreen_width - 32, height: CGFloat.greatestFiniteMagnitude))
        container.maximumNumberOfRows = 3
        container.truncationType = .end
        container.size = size
        let layOut = YYTextLayout(container: container, text: attString)
//        let layOut = YYTextLayout(containerSize: size, text: attString)
        
        print("内容高度==\(layOut?.textBoundingSize.height)")
        return layOut
    }
    var otherHeight: CGFloat? {

        var height: CGFloat = 0
        
        if let str = self.imgs,str.isEmpty == false {
            let imageArr = str.components(separatedBy: ",")
            let count = imageArr.count
            let culom:Int = Int((ceil(CGFloat(CGFloat(count) / 3))))
            let hei1:CGFloat = CGFloat(culom) * ((kScreen_width) - 52) / 3
            let hei2:CGFloat =  CGFloat((culom - 1) * 10)
            height = hei1 + hei2
        }

        
        
        return 16 + 40 + 12 + height + 12 + 12 + 10
    }

}

class myCell: UICollectionViewCell {
    lazy var imgv: UIImageView = {
        let result = UIImageView(frame: CGRect(x: 0, y: 0, width: (kScreen_width - 32 - 20) / 3, height: (kScreen_width - 32 - 20) / 3))
        result.contentMode = .scaleAspectFill
        result.layer.masksToBounds = true
        return result
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgv)
    }
    func fillData(str: String) {
        imgv.image = UIImage(named: str)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
