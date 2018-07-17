//
//  ArticleVM.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Kanna
import Moya
import RxAlamofire

class ArticleVM{
    
    private let word: String
    let subject: PublishRelay<ArticleModel>
    private var count = 1
    
    init(_ word: String) {
        self.word = word
        subject = PublishRelay()
        loadData()
    }
    
    func reloadData(){
        count += 1
        loadData()
    }
    
    private func loadData(){
        _ = MoyaProvider<API>().rx.request(.getNews(word: word, count: count))
            .do(onSuccess: { _ in print("success") }, onError: { _ in print("err") }, onSubscribe: { print("subscribe") }, onSubscribed: { print("ed") }, onDispose: { print("dispose") })
            .filter(statusCode: 200)
            .map(ArticleListModel.self)
            .asObservable()
            .map{ $0.items }
            .flatMap{ Observable.from($0) }
            .subscribe(onNext: { [unowned self] in
                self.subject.accept($0)
            })
        
//        _ = requestData(getRequest())
//            .single()
//            .filter{ $0.0.statusCode == 200 }
//            .map{ $0.1 }
//            .map{ try! JSONDecoder().decode(ArticleListModel.self, from: $0) }
//            .flatMap{ Observable.from($0.items) }
//            .subscribe(onNext: { [unowned self] in
//                self.subject.accept($0)
//            })
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
