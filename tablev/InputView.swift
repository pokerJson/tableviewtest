//
//  InputView.swift
//  tablev
//
//  Created by CYAX_BOY on 2020/12/13.
//

import UIKit

class InputView: UIView, UITextViewDelegate {

    var handle: (() -> ())?
    var handle2: (() -> ())?

    lazy var bgView: UIView = {
        let result = UIView()
        return result
    }()
    lazy var txtView: UITextView = {
        let result = UITextView()
        result.delegate = self
        result.backgroundColor = .gray
        result.font = UIFont.systemFont(ofSize: 15)
        return result
    }()
    lazy var btn: UIButton = {
        let result = UIButton(type: .custom)
        result.setTitle("发表", for: .normal)
        result.setTitleColor(.red, for: .normal)
        return result
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(bgView)
        addSubview(btn)
        bgView.addSubview(txtView)
        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbFrameChanged2(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.frame.size.height)

        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-76)
            make.bottom.equalToSuperview().offset(-5)
        }
        txtView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        btn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }


    }
    func textViewDidChange(_ textView: UITextView) {
        let hei = self.getHeight(str: textView.text)
        print("heithtt==\(self.getHeight(str: textView.text))")
        if hei > 34 {
//            handle?()
            self.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(kScreen_height - 80)
                make.left.right.equalToSuperview()
                make.height.equalTo(80)
            }

        }else{
//            handle2?()
            self.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(kScreen_height - 60)
                make.left.right.equalToSuperview()
                make.height.equalTo(60)
            }

        }
    }
   private func getHeight(str: String) -> CGFloat {
        return str.boundingRect(with: CGSize(width: kScreen_width - 16 - 76, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)], context:nil).size.height;
    }
    
    @objc func kbFrameChanged(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }
    @objc func kbFrameChanged2(_ notification : Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }

}
