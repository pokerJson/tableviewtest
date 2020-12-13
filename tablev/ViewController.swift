//
//  ViewController.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/5.
//

import UIKit
import YYKit

let kScreen_width = UIScreen.main.bounds.width
let kScreen_height = UIScreen.main.bounds.height

class ViewController: UIViewController {
    lazy var headerV: HeaderView = {
        let header = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        return header
    }()
    lazy var input: InputView = {
        let header = InputView()
        return header
    }()

    lazy var tabView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.register(TableViewCell.self, forCellReuseIdentifier: "cell")
//        tab.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tab.estimatedRowHeight = 150
        return tab
    }()
    var okmodel: OKModel!
    var arr: [OKModel] = [OKModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tabView)
        tabView.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: kScreen_height)
        tabView.tableHeaderView = headerV
        okmodel = OKModel()
        okmodel.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel.name = "李德华"
        okmodel.content = "阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        okmodel.imgs = "1,5,6,7"
//        okmodel.imgs = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=2328a8d844492b76be349b487051fd3d&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F2f6ae348b19c83fdc721ca5a54d4adb8d7455fa31dc76-GMqiCq_fw658,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495699&di=e7d019158c3f1094edbf55b7f8b8bc03&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F430eb25ca84a728281c7885c028cfa33d88aaa0f2bd31-KtuQa4_fw658,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185614521&di=026632df88f9ea0683aeda3ca10c4b30&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2F7%2Fb2%2Fc03f1298426.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185614518&di=f3be5e14cb7621e8bfb7d76c74fb6edf&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2F%2Fpic%2F2%2F6b%2F7caee3d426.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185683687&di=cef6b26588a56e2af1942b90bdd905ce&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F27%2F67%2F01300000921826141299672233506.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185683686&di=f63ff28cde2506f9b1d815cdc60b64f1&imgtype=0&src=http%3A%2F%2Fa2.att.hudong.com%2F42%2F31%2F01300001320894132989315766618.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185683686&di=4cb2919c067f018ea05e6a8866cd87d5&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F35%2F34%2F19300001295750130986345801104.jpg"
        headerV.fillData(model: okmodel)
        var height: CGFloat = 0
        
        if let str = okmodel.imgs,str.isEmpty == false {
            let imageArr = str.components(separatedBy: ",")
            let count = imageArr.count
            let culom:Int = Int((ceil(CGFloat(CGFloat(count) / 3))))
            let hei1:CGFloat = CGFloat(culom) * ((kScreen_width) - 52) / 3
            let hei2:CGFloat =  CGFloat((culom - 1) * 10)
            height = hei1 + hei2
        }
            
        
        
        
        let allheight = 16+40+12+getHeight(str:okmodel.content!) + 12 + 12 + 20 + height + 16
        headerV.frame = CGRect(x: 0, y: 0, width: kScreen_width, height: allheight)
        headerV.backgroundColor = .red
        //arr
       let okmodel1 = OKModel()
        okmodel1.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel1.name = "3张"
        okmodel1.content = "阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        okmodel1.imgs = "1,5,6,7"
        let okmodel2 = OKModel()
        okmodel2.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel2.name = "6张"
        okmodel2.content = "gggggg阿萨德放假阿士大夫撒旦"
        okmodel2.imgs = "1,3,2,5,6,7"
        let okmodel3 = OKModel()
        okmodel3.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel3.name = "没有"
        okmodel3.content = "aaaaaaa阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        let okmodel4 = OKModel()
        okmodel4.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel4.name = "3张"
        okmodel4.content = "4aaaaaaa阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        okmodel4.imgs = "1,3,2"
        let okmodel5 = OKModel()
        okmodel5.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel5.name = "2张"
        okmodel5.content = "4aaaaaaa阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        okmodel5.imgs = "1,2"
        let okmodel6 = OKModel()
        okmodel6.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel6.name = "没有"
        okmodel6.content = "发送到发送到rrr4aaaaaaa阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        let okmodel7 = OKModel()
        okmodel7.photo = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1607185495700&di=decb79573f593e5609da5c23f3ef5595&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2Fb%2F7b%2F1a0a1305442.jpg"
        okmodel7.name = "8张"
        okmodel7.content = "eeeeee发送到发送到rrr4aaaaaaa阿萨德放假阿士大夫撒旦aadsfasdlasdfasdfas发送到发斯蒂芬斯蒂芬阿斯顿发斯蒂芬；是打发斯蒂芬拉水电费；撒打发斯蒂芬辣三丁；阿斯顿发斯蒂芬阿斯蒂芬阿斯顿发斯蒂芬水电费阿萨德放假ask的房价阿斯利康打飞机阿里斯柯达阿斯顿发生为二位融通"
        okmodel7.imgs = "1,2,3,4,5,6,7,8"
        arr.append(okmodel1)
        arr.append(okmodel2)
        arr.append(okmodel3)
        arr.append(okmodel4)
        arr.append(okmodel5)
        arr.append(okmodel6)
        arr.append(okmodel7)
        tabView.reloadData()

//        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged2(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(input)
        input.handle = {
            self.input.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(kScreen_height - 80)
                make.left.right.equalToSuperview()
                make.height.equalTo(80)
            }
        }
        input.handle2 = {
            self.input.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(kScreen_height - 60)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }
        }

        input.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kScreen_height - 60)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
    }
//    @objc func kbFrameChanged(_ notification : Notification){
//        let info = notification.userInfo
//        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
//        UIView.animate(withDuration: 0.25) {
//            self.input.transform = CGAffineTransform(translationX: 0, y: offsetY)
//        }
//    }
//    @objc func kbFrameChanged2(_ notification : Notification){
//        let info = notification.userInfo
//        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
//        UIView.animate(withDuration: 0.25) {
//            self.input.transform = CGAffineTransform(translationX: 0, y: offsetY)
//        }
//    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        input.txtView.resignFirstResponder()
        input.txtView.text = ""
        self.input.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(kScreen_height - 60)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }

    }
    func getHeight(str: String) -> CGFloat {
        return str.boundingRect(with: CGSize(width: kScreen_width - 32, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context:nil).size.height + 10;
    }

}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 10
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arr[indexPath.row].otherHeight! + (arr[indexPath.row].textLayout?.textBoundingSize.height)!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabView.dequeueReusableCell(withIdentifier: "cell")! as! TableViewCell
        cell.fillData(model: (arr[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aa = CooletionviewVC()
        self.present(aa, animated: true) {
            
        }
        
    }
}
