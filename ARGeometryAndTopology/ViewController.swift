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
        torus.initShape()
        
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
    
//    A_ _ _ _ _ _ _ _ _ _ _ _D
//    |_|_|_|_|_|_|_|_|_|_|_|_|
//    |_|_|_|_|_|_|_|_|_|_|_|_|
//    |_|_|_|_|_|_|_|_|_|_|_|_|
//    |_|_|_|_|_|_|_|_|_|_|_|_|
//    B                       C
    // How to make a torus: glue A->B, D->C to make a tube then glue AB->DC to make a torus
    // variables
    let pieces = 16 // number of pieces for one tube => Total pieces: pieces^2
    let width = CGFloat(0.1) //AD
    let height = CGFloat(0.1) //AB
    let xLowerBound = -CGFloat(0.1)/2
    let yLowerBound = CGFloat(0.1)/2
    let length = CGFloat(0.002) // thickness of the torus
    lazy var plane = PlaneDisplay(scene: sceneView, pieceCount: pieces, w: width, h: height, l: length)
    lazy var torus = Torus(scene: sceneView,  pieceCount: pieces, w: width, h: height, l: length)
    var points: [SCNNode] = []
    var multipleCurve = false
    var planeCurrentCurves = SCNNode()
    var torusCurrentCurves = SCNNode()
    
    // Update curves on the screen
    @IBAction func addTorus(_ sender: Any) {
        print(multipleCurve)
        if (multipleCurve == false){
            torus.plane.curvePoints = points
            torus.add()

        } else {
            sceneView.scene.rootNode.addChildNode(planeCurrentCurves)
            sceneView.scene.rootNode.addChildNode(torusCurrentCurves)
            torus.plane.curvePoints = points
            torus.add()
        }
        
    }
    
    // Add new curve but still keeps old one displayed
    @IBAction func updateCurve(_ sender: UIButton) {
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.gray
        recolor(node: torus.plane.curvePointNode)
        recolor(node: torus.plane.line)
        recolor(node: torus.curvePointNode)
        recolor(node: torus.line)
        planeCurrentCurves.addChildNode(torus.plane.curvePointNode)
        planeCurrentCurves.addChildNode(torus.plane.line)
        torusCurrentCurves.addChildNode(torus.curvePointNode)
        torusCurrentCurves.addChildNode(torus.line)
        

    }
    
    // Remove all
    @IBAction func removeTorus(_ sender: UIButton) {
        while (!self.sceneView.scene.rootNode.childNodes.isEmpty){
            self.sceneView.scene.rootNode.childNodes[0].removeFromParentNode()
        }
    }
    
    // change view
    @IBAction func changeView(_ sender: UIButton) {
        //performSegue(withIdentifier: "Switch", sender: UIButton())
    }

    // change color of old curves
    func recolor(node: SCNNode){
        let arr = node.childNodes
        for i in 0...arr.count-1 {
            arr[i].geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        }
    }
    
    // shortening process (step by step_
    @IBAction func shortenCurve(_ sender: UIButton) {
        torus.shorten()

    }

    // navigate to 2D view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "switchTo2D" {
            if let twoDView = segue.destination as? TwoDViewController {
                twoDView.width = width
                twoDView.height = height
                twoDView.xLowerBound = xLowerBound
                twoDView.yLowerBound = yLowerBound
                multipleCurve = false
                twoDView.multipleCurve = multipleCurve
            }
        }
        if segue.identifier == "updateCurve"{
            if let twoDView = segue.destination as? TwoDViewController {
                twoDView.width = width
                twoDView.height = height
                twoDView.xLowerBound = xLowerBound
                twoDView.yLowerBound = yLowerBound
                twoDView.torusCurrentCurves = torusCurrentCurves
                twoDView.planeCurrentCurves = planeCurrentCurves
                multipleCurve = true
                twoDView.multipleCurve = multipleCurve
            }
        }

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


