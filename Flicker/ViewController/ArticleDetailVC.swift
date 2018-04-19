//
//  ArticleDetailView.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleDetailVC: UIViewController {
    
    var url: String!
    private var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setWebView()
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    private func setWebView(){
        let frame = view.safeAreaLayoutGuide.layoutFrame
        webView = UIWebView(frame: frame)
        view.addSubview(webView)
        setTitle("로딩 중입니다.")
        _ = webView.rx.didFinishLoad
            .map{"로딩 완료!"}
            .subscribe(onNext: { [unowned self] in self.setTitle($0) })
    }
    
    private func setTitle(_ text: String){
        navigationController?.title = text
    }

}
