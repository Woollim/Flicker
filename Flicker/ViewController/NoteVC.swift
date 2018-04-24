//
//  NoteVC.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm
import RxKeyboard

class NoteVC: UIViewController {

    @IBOutlet weak var hideKeyboardButton: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var keywordTextField: UITextField!
    
    private let disposeBag = DisposeBag()
    var word: String = ""
    var data: NoteModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        hideKeyboardButton.layer.cornerRadius = 8
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
    }
    
    private func setData(){
        if let data = self.data{
            self.word = data.word
            keywordTextField.text = data.shortDesc
            textView.text = data.content
        }
        wordLabel.text = "\"\(word)\""
    }
    
    override func viewDidLayoutSubviews() {
        let paddingHeight = view.safeAreaInsets.bottom
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let isDown = height == 0
                self.bottomHeightConstraint.constant = isDown ? 4 : height - paddingHeight + 4
                self.buttonConstraint.constant = isDown ? 4 : height - paddingHeight + 4
                self.hideKeyboardButton.isHidden = isDown
            }).disposed(by: disposeBag)
        hideKeyboardButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in self.view.endEditing(true) })
            .disposed(by: disposeBag)
    }

}

extension NoteVC{
    
    @IBAction func showArticle(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleVC") as! ArticleVC
        vc.word = word
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveNote(){
        if let data = self.data{
            _ = Observable.just(data)
                .subscribe(Realm.rx.delete())
        }
        let data = NoteModel()
        data.word = word
        data.shortDesc = keywordTextField.text!
        data.content = textView.text
        _ = Observable.just(data)
            .subscribe(Realm.rx.add())
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
