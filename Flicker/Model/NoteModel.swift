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
    
    var word: String = "안녕"
    var articleUrlArr = List<String>()
    var shortDesc: String = "오늘의 날씨입니다."
    var title: String = ""
    var content: String = ""
    var date: Date = Date()
    
}
