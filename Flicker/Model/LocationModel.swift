//
//  LocationModel.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 18..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import UIKit

class LocationModel{
    
    var x: CGFloat = 0, y: CGFloat = 0
    private let marginSize: CGFloat = 4
    
    init(_ buttonSize: CGFloat, size: CGSize) {
        x = getRandNum(size.width - buttonSize)
        y = (getRandNum(size.height - buttonSize))
    }

    private func getRandNum(_ max: CGFloat) -> CGFloat{
        return CGFloat(arc4random()).truncatingRemainder(dividingBy: max - marginSize * 2) + marginSize
    }
    
}
