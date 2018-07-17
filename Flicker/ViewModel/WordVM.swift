//
//  WordViewModel.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 15..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxAlamofire
import Kanna
import Moya

class WordVM{
    
    private var dataArr = [String]()
    let subject: PublishSubject<(String, LocationModel)>
    private let url = "https://ko.wiktionary.org/wiki/%EB%B6%80%EB%A1%9D:%EC%9E%90%EC%A3%BC_%EC%93%B0%EC%9D%B4%EB%8A%94_%ED%95%9C%EA%B5%AD%EC%96%B4_%EB%82%B1%EB%A7%90_5800"
    
    private let buttonSize: CGFloat
    private var safeSize: CGSize!
    private var safeTop: CGFloat!
    
    init(_ buttonSize: CGFloat) {
        self.buttonSize = buttonSize
        subject = PublishSubject()
        initLoadData()
    }
    
    private func initLoadData(){
        _ = MoyaProvider<API>().rx.request(.getWords)
            .filter(statusCode: 200)
            .map{ $0.data }
            .map{ try! HTML(html: $0, encoding: .utf8) }
            .map{ $0.css("table.prettytable :first-child dd") }
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.dataArr = data.makeIterator().map{ $0.content! }
                }, onDisposed: { [weak self] in self?.getData() })
        
        
//        _ = request(.get, URL(string: url)!)
//            .observeOn(ConcurrentMainScheduler.instance).responseString()
//            .single()
//            .filter{ (res, _) in res.statusCode == 200 }
//            .map{ (_, str) in str }
//            .map{ try! HTML(html: $0, encoding: .utf8) }
//            .map{ $0.css("table.prettytable :first-child dd") }
//            .subscribe(onNext: { [unowned self] data in
//                self.dataArr = data.makeIterator().map{ $0.content! }
//                }, onDisposed: { [unowned self] in self.getData() })
    }
    
    func setViewSize(_ size: CGSize){
        self.safeSize = size
    }
    
    func getData(){
        if dataArr.count == 0 { return }
        
        let wordData = Observable.range(start: 0, count: 5)
            .map{ [unowned self] _ in UInt32(self.dataArr.count) }
            .map{ Int(arc4random_uniform($0)) }
            .map{ [unowned self] index in self.dataArr.remove(at: index) }
        
        _ = Observable.zip(wordData, getLocationObservable()){ ($0, $1) }
            .subscribe(onNext: { [unowned self] in
                self.subject.onNext($0)
            })
    }
    
    private func getLocationObservable() -> Observable<LocationModel>{
        var locationArr = [LocationModel]()
        mainLoop: while locationArr.count < 5 {
            let newData = LocationModel(buttonSize, size: safeSize)
            for location in locationArr{
                if !(checkVaild(new: newData.x, old: location.x) || checkVaild(new: newData.y, old: location.y)){
                    continue mainLoop
                }
            }
            locationArr.append(newData)
        }
        return Observable.from(locationArr)
    }
    
    private func checkVaild(new: CGFloat, old: CGFloat) -> Bool{
        return new > (old + buttonSize) || (new + buttonSize) < old
    }
    
}
