//
//  ViewController.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 5/23/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    

    @IBOutlet var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
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
    // variables
    let r = CGFloat(0.1) //0.1
    let pieces = 36
    let height = CGFloat(0.1) //0.05
    let length = CGFloat(0.002)
    lazy var torus = TorusWithPoints(scene: sceneView, radius: r, pieceCount: pieces, h: height, l: length)
    lazy var curve = Curve(scene: sceneView, radius: r)
    @IBAction func addTorus(_ sender: Any) {
        
        
        // plane

        torus.add()
        
        
        //curve.add()

    }
    
    @IBAction func removeTorus(_ sender: UIButton) {
        torus.removeAllElements()
        while (!self.sceneView.scene.rootNode.childNodes.isEmpty){
            self.sceneView.scene.rootNode.childNodes[0].removeFromParentNode()
        }
    }
    
    @IBAction func recolorTorus(_ sender: UIButton) {
        if (!self.sceneView.scene.rootNode.childNodes.isEmpty){
            self.sceneView.scene.rootNode.childNodes.forEach { node in
                let color = node.geometry?.firstMaterial?.diffuse.contents
                if ( UIColor.white.isEqual(color)){
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
                } else {
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                }
            }
        }
    }
    
    @IBAction func shortenCurve(_ sender: UIButton) {
        torus.shorten()

    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else {return}
//        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
//        guard let hitFeature = results.last else { return }
//        let hitTransform = SCNMatrix4.init(hitFeature.worldTransform) // <- if higher than beta 1, use just this -> hitFeature.worldTransform
//        let hitPosition = SCNVector3Make(hitTransform.m41,
//                                         hitTransform.m42,
//                                         hitTransform.m43)
//        curve.createBall(hitPosition: hitPosition)
//    }
    

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
