//
//  TouchScrollView.swift
//  ARKitFurnitureArrangementSample
//
//  Created by SIN on 2017/09/06.
//  Copyright © 2017年 js.ne.sapporoworks. All rights reserved.
//

import UIKit

protocol ScrollViewDelegate{
    func scrollViewTapped(tag: Int)
}

class TouchScrollView: UIScrollView {
    
    var Delegate: ScrollViewDelegate!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            Delegate.scrollViewTapped(tag: touch.view!.tag)
        }
    }
}


