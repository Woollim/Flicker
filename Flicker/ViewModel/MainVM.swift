//
//  MainViewModel.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 18..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation

import RxSwift
import RxRealm
import RealmSwift

class MainVM{
    
    private let data: Results<NoteModel>
    private let disposeBag = DisposeBag()
    let subject = PublishSubject<RealmChangeset>()
    
    init() {
        let realm = try! Realm()
        data = realm.objects(NoteModel.self)
        Observable.changeset(from: data)
            .map{ $1 }
            .filter{ $0 != nil }
            .map{ $0! }
            .subscribe(subject)
            .disposed(by: disposeBag)
    }
    
    func getArr() -> Results<NoteModel>{
        return data
    }
    
}
