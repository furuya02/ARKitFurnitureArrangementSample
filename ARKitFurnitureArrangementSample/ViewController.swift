//
//  ViewController.swift
//  ARKitFurnitureArrangementSample
//
//  Created by SIN on 2017/09/05.
//  Copyright © 2017年 js.ne.sapporoworks. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ScrollViewDelegate, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controlView: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    var isMenuOpen = true
    @IBOutlet weak var scrollView: TouchScrollView!
    
    var recordingButto: RecordingButton!
    var planeNodes:[PlaneNode] = []
    
    var sofaNode: SCNNode?
    let movement:Float = 0.05

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.Delegate = self
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        
        menuView.translatesAutoresizingMaskIntoConstraints = true
        toggleMenu()
        initializeMenu()
        
        self.recordingButto = RecordingButton(self) // 録画ボタン
        
        controlView.backgroundColor = UIColor(white: 0, alpha: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // 平面の検出を有効化する
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    // MARK; - Control
    @IBAction func moveUp(_ sender: Any) {
        sofaNode?.position = SCNVector3((sofaNode?.position.x)!, (sofaNode?.position.y)!, (sofaNode?.position.z)! - movement)
    }
    
    @IBAction func moveDown(_ sender: Any) {
        sofaNode?.position = SCNVector3((sofaNode?.position.x)!, (sofaNode?.position.y)!, (sofaNode?.position.z)! + movement)
    }

    @IBAction func moveRight(_ sender: Any) {
        sofaNode?.position = SCNVector3((sofaNode?.position.x)! + movement, (sofaNode?.position.y)!, (sofaNode?.position.z)! )
    }
    
    @IBAction func moveLeft(_ sender: Any) {
        sofaNode?.position = SCNVector3((sofaNode?.position.x)! - movement, (sofaNode?.position.y)!, (sofaNode?.position.z)! )
    }
    @IBAction func rotation(_ sender: Any) {
        sofaNode?.physicsBody?.applyTorque(SCNVector4(0, 10, 0, -1.0), asImpulse:false)
    }
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 平面を表現するノードを追加する
                let panelNode = PlaneNode(anchor: planeAnchor)
                panelNode.isDisplay = true
                
                node.addChildNode(panelNode)
                self.planeNodes.append(panelNode)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                // ノードの位置及び形状を修正する
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
    
    // MAEK: - Menu View
    @IBAction func menuButtonTapperd(_ sender: UIButton) {
        toggleMenu()
    }
    
    func toggleMenu() {
        if isMenuOpen {
            controlView.isHidden = false
            isMenuOpen = false
            menuButton.setImage(UIImage(named:"open"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame.origin.y = UIScreen.main.bounds.height - 50
            })
        } else {
            controlView.isHidden = true
            for imageView in scrollView.subviews {
                imageView.layer.borderWidth = 0
            }
            isMenuOpen = true
            menuButton.setImage(UIImage(named:"close"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame.origin.y = UIScreen.main.bounds.height - 300
            })
        }
    }
    
    func initializeMenu() {
        let imageWidth = 250
        let imageHeight = 200
        let margin = 20
        let imageNames = ["sofa_001","sofa_002","sofa_003","sofa_004"]
        
        scrollView.contentSize = CGSize(width: (imageWidth + margin) * imageNames.count , height: imageHeight)
        scrollView.isUserInteractionEnabled = true

        for i:Int in 0 ..< imageNames.count {
            let imageView = UIImageView(image: UIImage(named: imageNames[i]))
            imageView.tag = i + 1
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 0
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
 
            let offSet = i * (imageWidth + margin)
            imageView.frame = CGRect(x: offSet, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(imageView)
        }
        
        menuView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    // MAEK: - append Sofa Node
    func scrollViewTapped(tag: Int) {
        let imageView = scrollView.subviews[tag-1]
        imageView.layer.borderWidth = 10
        
        self.toggleMenu()
        
        if sofaNode != nil {
            sofaNode?.removeFromParentNode()
        }

        
        let hitTestResult = sceneView.hitTest(sceneView.center, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            if let hitResult = hitTestResult.first {
                
                let sceneName = ["sofa001","sofa002","sofa003","sofa004"]
                let assetsName = "art.scnassets"
                let sofaWidth:[CGFloat] = [1.7, 1.7, 0.8, 1.0]
                sofaNode = Furniture.create(sceneName: "\(assetsName)/\(sceneName[tag-1]).scn", width: sofaWidth[tag-1])
                sofaNode?.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                sofaNode?.physicsBody?.categoryBitMask = 1
                sofaNode?.physicsBody?.restitution = 0// 弾み具合　0:弾まない 3:弾みすぎ
                sofaNode?.physicsBody?.damping = 1  // 空気の摩擦抵抗 1でゆっくり落ちる
                sofaNode?.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + Float(0.1), hitResult.worldTransform.columns.3.z)
                sceneView.scene.rootNode.addChildNode(sofaNode!)
            }
        }
    }
}

