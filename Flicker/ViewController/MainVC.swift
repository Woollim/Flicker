//
//  ViewController.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 11..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import UIKit
import RealmSwift

import RxRealm
import RxSwift
import RxCocoa

class MainVC: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private var vm: MainVM!
    private var initDataArr: Results<NoteModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = MainVM()
        initDataArr = vm.getArr()
        vm.subject.subscribe(onNext: { [unowned self] changes in
            self.tableView.applyChangeset(changes)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func add(_ sender: Any) {
        showAlert()
    }
    
}

extension MainVC{
    
    private func showAlert(){
        let alert = UIAlertController(title: "노트 유형을 선택해주세요", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = Color.main.getColor()
        alert.setAction("번뜩 노트", style: .default){ _ in self.goWordVC() }
        alert.setAction("사용자 입력 노트", style: .default){ _ in self.goNoteVC() }
        alert.setAction("취소", style: .cancel)
        present(alert, animated: true)
    }
    
    private func goNoteVC(){
        let alert = UIAlertController(title: "핵심 단어를 입력해주세요.", message: nil, preferredStyle: .alert)
        alert.view.tintColor = Color.main.getColor()
        alert.addTextField(configurationHandler: nil)
        alert.setAction("입력완료", style: .default){ _ in
            let textField = alert.textFields![0]
            let vc = self.goNextView("NoteVC") as! NoteVC
            vc.word = textField.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        alert.setAction("취소", style: .cancel)
        present(alert, animated: true)
    }
    
    private func goWordVC(){
        self.navigationController?.pushViewController(goNextView("WordVC"), animated: true)
    }
    
    private func goNextView(_ id: String) -> UIViewController{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: id)
        return vc!
    }
    
}

extension MainVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = initDataArr.count
        if count == 0 {
            let view = EmptyView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
            view.clickFunc = showAlert
            tableView.backgroundView = view
            tableView.separatorStyle = .none
            return 0
        }else{
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = initDataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        cell.setTitle(data.word)
        cell.shortDescLabel.text = data.shortDesc
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = goNextView("NoteVC") as! NoteVC
        vc.data = initDataArr[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            _ = Observable.just(initDataArr[indexPath.row])
                .bind(to: Realm.rx.delete())
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}

extension UIAlertController{
    
    func setAction(_ title: String, style: UIAlertActionStyle, fun: ((UIAlertAction) -> Swift.Void)? = nil){
        self.addAction(UIAlertAction(title: title, style: style, handler: fun))
    }
    
}

extension UITableView{
    
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
    
}

class MainCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    
    override func awakeFromNib() {
        titleLabel.textColor = Color.main.getColor()
    }
    
    func setTitle(_ title: String){
        titleLabel.text = "\"\(title)\""
    }
    
}
