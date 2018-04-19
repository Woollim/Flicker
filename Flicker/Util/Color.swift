//
//  Color.swift
//  Flicker
//
//  Created by 이병찬 on 2018. 4. 18..
//  Copyright © 2018년 W_Vertex. All rights reserved.
//

import Foundation
import UIKit

enum Color{
    
    case main
    case lightGray
    
    func getColor() -> UIColor{
        switch self {
        case .main:
            return UIColor(red: 243/255, green: 210/255, blue: 62/255, alpha: 1)
        case .lightGray:
            return UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        }
    }
    
}
