//
//  ArticleVM.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import RxSwift
import Kanna
import RxAlamofire

class ArticleVM{
    
    private let word: String
    let subject: PublishSubject<ArticleModel>
    private var count = 1
    
    init(_ word: String) {
        self.word = word
        subject = PublishSubject()
        loadData()
    }
    
    func reloadData(){
        count += 1
        loadData()
    }
    
    private func loadData(){
        _ = requestData(getRequest())
            .single()
            .filter{ $0.0.statusCode == 200 }
            .map{ $0.1 }
            .map{ try! JSONDecoder().decode(ArticleListModel.self, from: $0) }
            .flatMap{ Observable.from($0.items) }
            .subscribe(onNext: { [unowned self] in
                self.subject.onNext($0)
            })
    }
    
    private func getRequest() -> URLRequest{
        let requestLink = "https://openapi.naver.com/v1/search/news.json?start=\(count)&query="
        let encodead = (requestLink + word).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request = URLRequest(url: URL(string: encodead)!)
        request.httpMethod = "GET"
        request.addValue("MZOETpAGCVBGuheQ85h4", forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue("it5ryrxT6K", forHTTPHeaderField: "X-Naver-Client-Secret")
        return request
    }
    
}
