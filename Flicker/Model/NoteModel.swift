//
//  NoteModel.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 18..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import RealmSwift

class NoteModel: Object{
    
    @objc dynamic var word: String = "안녕"
    @objc dynamic var shortDesc: String = "오늘의 날씨입니다."
    @objc dynamic var content: String = ""
    let date: Date = Date()
    
}
