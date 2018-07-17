//
//  Connector.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 7. 15..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import Moya

enum API{
    
    case getWords, getNews(word: String, count: Int)
    
}

extension API: TargetType{
    
    var baseURL: URL {
        if case API.getNews(let word, let count) = self{
            let baseUrl = "https://openapi.naver.com/v1/search/news.json?start=\(count)&query="
            let url = (baseUrl + word).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return URL(string: url)!
        }else{
            let url = "https://ko.wiktionary.org/wiki/%EB%B6%80%EB%A1%9D:%EC%9E%90%EC%A3%BC_%EC%93%B0%EC%9D%B4%EB%8A%94_%ED%95%9C%EA%B5%AD%EC%96%B4_%EB%82%B1%EB%A7%90_5800"
            return URL(string: url)!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        return Task.requestPlain
    }
    
    var headers: [String : String]? {
        if case API.getNews(_) = self{
            return ["X-Naver-Client-Id" : "MZOETpAGCVBGuheQ85h4", "X-Naver-Client-Secret" : "it5ryrxT6K"]
        }else{
            return nil
        }
    }
    
}
