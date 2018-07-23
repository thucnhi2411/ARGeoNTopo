//
//  TwoDViewController.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 7/19/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class TwoDViewController: UIViewController, SKViewDelegate {


    @IBOutlet weak var skView: SKView!
    var width  = CGFloat()
    var height = CGFloat()
    var xLowerBound = CGFloat()
    var yLowerBound = CGFloat()
    var scene = PlaneScene(size: CGSize(width: 0, height: 0))
    var planeCurrentCurves = SCNNode()
    var torusCurrentCurves = SCNNode()
    var multipleCurve = false
    
    
    
    override func viewDidLoad() {
        self.title = "2DView"
        scene = PlaneScene(size: view.frame.size)
        //scene = SKScene(size: view.frame.size)
        //scene.scaleMode = .resizeFill
        scene.width3D = width
        scene.height3D = height
        scene.xLowerBound = xLowerBound
        scene.yLowerBound = yLowerBound
        skView.presentScene(scene)

        
        // Do any additional setup after loading the view.
    }

    @IBAction func displayPlane(_ sender: UIButton) {
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: scene)
        scene.addPoint(location: location)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "switchToAR" {
            if let ARView = segue.destination as? ViewController {
                ARView.points = scene.points
                ARView.planeCurrentCurves = planeCurrentCurves
                ARView.torusCurrentCurves = torusCurrentCurves
                ARView.multipleCurve = multipleCurve
            }
        }
        
    }



}
