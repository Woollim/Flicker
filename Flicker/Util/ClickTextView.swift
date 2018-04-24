//
//  ClickTextView.swift
//  Flicker
//
//  Created by 이병찬 on 22/04/2018.
//  Copyright © 2018 W_Vertex. All rights reserved.
//

import Foundation
import UIKit

class ClickTextView: UITextView{
    
    var clickFunc: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDoubleTab(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handlePressGesture(recogizer:)))
        gesture.minimumPressDuration = 0.1
        self.addGestureRecognizer(gesture)
    }
    
    @objc func handlePressGesture(recogizer: UILongPressGestureRecognizer){
        if recogizer.state == .began{
            clickFunc?()
        }
    }
    
}
