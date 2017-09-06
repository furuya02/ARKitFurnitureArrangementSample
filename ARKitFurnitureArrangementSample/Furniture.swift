//
//  Furniture.swift
//  ARKitFurnitureArrangementSample
//
//  Created by SIN on 2017/09/05.
//  Copyright © 2017年 js.ne.sapporoworks. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Furniture {
    
    static func create(sceneName: String, nodeName: String, width: CGFloat) -> SCNNode {
        // シーンからノードを取り出す
        let scene = SCNScene(named: sceneName)!
        let node = scene.rootNode.childNode(withName: nodeName, recursively: true)

        // 縮尺を計算してスケールを調整する
        let (min, max) = (node?.boundingBox)!
        let w = CGFloat(max.x - min.x)
        let magnification = width / w
        node?.scale = SCNVector3(magnification, magnification, magnification)
        return node!
    }
}

