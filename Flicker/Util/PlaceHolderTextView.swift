//
//  PlaceHolderTextView.swift
//  Flicker
//
//  Created by 이병찬 on 24/04/2018.
//  Copyright © 2018 W_Vertex. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class PlaceHolderTextView: UITextView{
    
    private var label: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addPlaceHolder()
        emit()
    }
    
    private func addPlaceHolder(){
        let padding = textContainer.lineFragmentPadding
        label = UILabel(frame: CGRect(x: padding, y: padding, width: 208, height: 24))
        label?.text = "내용을 입력하세요"
        label?.textAlignment = self.textAlignment
        label?.textColor = UIColor.lightGray
        self.addSubview(label!)
    }
    
    private func emit(){
        _ = rx.textInput.text
            .map{ $0!.count }
            .subscribe(onNext: { [unowned self] size in
                if size == 0{ self.label?.alpha = 1 }
                else{ self.label?.alpha = 0 }
            })
    }
    
}
