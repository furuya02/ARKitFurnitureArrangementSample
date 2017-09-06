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
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    var isMenuOpen = true
    @IBOutlet weak var scrollView: TouchScrollView!
    
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
        
//        let sofa001 = Furniture.create(sceneName: "art.scnassets/sofa001.scn", nodeName: "sofa", width: 2.5)
//        sofa001.position = SCNVector3(0,-1,-1)
//        sceneView.scene.rootNode.addChildNode(sofa001)

//        let sofa002 = Furniture.create(sceneName: "art.scnassets/sofa002.scn", nodeName: "sofa", width: 2.5)
//        sofa002.position = SCNVector3(0,-1,-1)
//        sceneView.scene.rootNode.addChildNode(sofa002)

//        let sofa003 = Furniture.create(sceneName: "art.scnassets/sofa003.scn", nodeName: "sofa", width: 1.0)
//        sofa003.position = SCNVector3(0,-1,-1)
//        sceneView.scene.rootNode.addChildNode(sofa003)

        let sofa004 = Furniture.create(sceneName: "art.scnassets/sofa004.scn", nodeName: "sofa", width: 2.0)
        sofa004.position = SCNVector3(0,-1,-2)
        sceneView.scene.rootNode.addChildNode(sofa004)
        
        menuView.translatesAutoresizingMaskIntoConstraints = true
        toggleMenu()
        initializeMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MAEK: - Menu View
    @IBAction func menuButtonTapperd(_ sender: UIButton) {
        toggleMenu()
    }
    
    func toggleMenu() {
        if isMenuOpen {
            self.isMenuOpen = false
            self.menuButton.setImage(UIImage(named:"open"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame.origin.y = UIScreen.main.bounds.height - 50
            })
        } else {
            self.isMenuOpen = true
            self.menuButton.setImage(UIImage(named:"close"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame.origin.y = UIScreen.main.bounds.height - 300
            })
        }
    }
    
    func initializeMenu() {
        let imageWidth = 250
        let imageHeight = 200
        let margin = 20
        let imageNames = ["001","002","003","004"]
        
        scrollView.contentSize = CGSize(width: (imageWidth + margin) * imageNames.count , height: imageHeight)
        scrollView.isUserInteractionEnabled = true

        for i:Int in 0 ..< imageNames.count {
            let imageView = UIImageView(image: UIImage(named: imageNames[i]))
            imageView.tag = i + 1
            imageView.isUserInteractionEnabled = true
            let offSet = i * (imageWidth + margin)
            imageView.frame = CGRect(x: offSet, y: 0, width: imageWidth, height: imageHeight)
            scrollView.addSubview(imageView)
        }
        
        menuView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func scrollViewTapped(tag: Int) {
        print("tapped -- \(tag)")
    }
}

