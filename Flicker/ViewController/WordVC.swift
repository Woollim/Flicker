//
//  CreateVC.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 18..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class WordVC: UIViewController{
    
    @IBOutlet weak var wordDisplayView: UIView!
    
    private let buttonSize: CGFloat = 62
    private var vm: WordVM!
    private let disposeBag = DisposeBag()
    private var buttonArr = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        vm = WordVM(buttonSize)
        vm.subject.subscribe(onNext: { [unowned self] in 
            self.createButton($0.0, x: $0.1.x, y: $0.1.y)
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = wordDisplayView.frame.size
        vm.setViewSize(size)
    }
    
    @IBAction func reload(){
        _ = Observable.from(buttonArr)
            .subscribe(onNext: { $0.removeFromSuperview() })
        vm.getData()
    }
    
}

extension WordVC{
    
    private func createButton(_ text: String, x: CGFloat, y: CGFloat){
        let button = WordButton(frame: CGRect(x: x, y: y, width: buttonSize, height: buttonSize))
        button.setTitle(text, for: .normal)
        addButton(button)
    }
    
    private func addButton(_ button: UIButton){
        buttonArr.append(button)
        wordDisplayView.addSubview(button)
        button.rx.tap
            .map{ button.title(for: .normal)! }
            .subscribe(onNext: { [unowned self] in self.showAlert($0) })
            .disposed(by: disposeBag)
    }
    
    private func goNextView(_ text: String){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleVC") as! ArticleVC
        vc.word = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func initView(){
        navigationItem.title = "단어 선택"
        wordDisplayView.layer.cornerRadius = 8
        wordDisplayView.backgroundColor = Color.lightGray.getColor()
    }
    
    private func showAlert(_ text: String){
        let alert = UIAlertController(title: text, message: "\"번뜩\" 단어로 선택하시겠어요?", preferredStyle: .alert)
        alert.view.tintColor = Color.main.getColor()
        alert.setAction("확인", style: .default, fun: { [unowned self] _ in self.goNextView(text) })
        alert.setAction("취소", style: .cancel)
        present(alert, animated: true)
    }
    
}

class WordButton: UIButton{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLayout() {
        backgroundColor = Color.main.getColor()
        setTitleColor(.white, for: .normal)
        titleLabel?.minimumScaleFactor = 0.5
        titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}
