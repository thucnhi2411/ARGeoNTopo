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
    lazy var curve = Curve(scene: sceneView)
    var odd = true
    @IBAction func addTorus(_ sender: Any) {
        // variables
        let r = CGFloat(0.1) //0.1
        let pieces = 720
        let height = CGFloat(0.05) //0.05
        let length = CGFloat(0.05)
        
        // plane
        //let torus = Torus(scene: sceneView, radius: r, pieceCount: pieces, h: height, l: length)
        //torus.add()
        
        
        curve.add()

    }
    
    @IBAction func removeTorus(_ sender: UIButton) {
        curve.removeAllElements()
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
        if (odd){
            curve.manipulateOdd()
        } else {
            curve.manipulateEven()
        }
        odd = !odd

    }
    
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
