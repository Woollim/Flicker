//
//  PlaceHolderTable.swift
//  Flicker
//
//  Created by 이병찬 on 24/04/2018.
//  Copyright © 2018 W_Vertex. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EmptyView: UIView{
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var button: UIButton!
    
    var clickFunc: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setInit()
        button.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.clickFunc?()
            }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setInit(){
        let view = UINib.init(nibName: "EmptyView", bundle: Bundle.init(for: type(of: self))).instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
}
