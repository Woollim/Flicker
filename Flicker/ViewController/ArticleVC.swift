//
//  ArticleVC.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import UIKit
import RxSwift

class ArticleVC: UITableViewController {
    
    var word: String!
    private var vm: ArticleVM!
    private var dataArr = [ArticleModel]()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        vm = ArticleVM(word)
        vm.subject.subscribe(onNext: { [unowned self] in
            let index = IndexPath(row: self.dataArr.count - 1, section: 0)
            self.dataArr.append($0)
            self.tableView.insertRows(at: [index], with: .automatic)
        }).disposed(by: disposeBag)
        setNavigationView()
    }
    
    @objc func reloadData(){
        _ = Observable.range(start: 0, count: dataArr.count)
            .subscribe(onNext: { [unowned self] _ in
                self.dataArr.remove(at: 0)
                let index = IndexPath(row: 0, section: 0)
                self.tableView.deleteRows(at: [index], with: .automatic)
            })
        vm.reloadData()
    }
    
    private func setNavigationView(){
        let reloadItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        navigationItem.rightBarButtonItem = reloadItem
        navigationItem.title = "\"\(word!)\" 관련 기사"
    }

}

extension ArticleVC{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let data = dataArr[indexPath.row]
        cell.textLabel?.text = data.title.convert()
        cell.detailTextLabel?.text = data.des.convert()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailVC") as! ArticleDetailVC
        vc.url = dataArr[indexPath.row].link
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
