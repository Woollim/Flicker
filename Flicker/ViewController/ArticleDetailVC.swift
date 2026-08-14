//
//  ArticleDetailView.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 19..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailVC: UIViewController {

    var url: String!
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard webView == nil else { return }
        setWebView()
        webView.load(URLRequest(url: URL(string: url)!))
    }

    private func setWebView(){
        var frame = view.safeAreaLayoutGuide.layoutFrame
        frame.size.height += view.safeAreaInsets.bottom
        webView = WKWebView(frame: frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        setTitle("로딩 중입니다.")
    }

    private func setTitle(_ text: String){
        navigationItem.title = text
    }

}

extension ArticleDetailVC: WKNavigationDelegate{

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setTitle("로딩 완료!")
    }

}
