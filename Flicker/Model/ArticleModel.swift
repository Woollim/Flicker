//
//  ArticleModel.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import RealmSwift
import Kanna

struct ArticleModel: Codable{
    
    var title: String
    let link: String
    var des: String
    
    enum CodingKeys: String, CodingKey {
        case title, link
        case des = "description"
    }
    
}

extension String{
    
    func convert() -> String{
        print(self)
        if let data = try? HTML(html: self, encoding: .utf8).content!{
            return data
        }else{
            return self
        }
    }
    
}

struct ArticleListModel: Codable {
    
    let items: [ArticleModel]
    let start: Int, display: Int
    
}
