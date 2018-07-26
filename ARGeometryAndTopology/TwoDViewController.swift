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

    // 2D view to adding points by touching the screen
    @IBOutlet weak var skView: SKView!          // view
    var width  = CGFloat()                      // width of AR plane
    var height = CGFloat()                      // height of AR plane
    var xLowerBound = CGFloat()                 // xLowerBound of AR plane
    var yLowerBound = CGFloat()                 // yLowerBound of AR plane
    var scene = PlaneScene(size: CGSize(width: 0, height: 0))   // scene
    var planeCurrentCurves = SCNNode()          // old curves on the AR plane
    var torusCurrentCurves = SCNNode()          // old curves on the AR shape
    var multipleCurve = false                   // whether creating or updating
    
    
    // set up
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

    
    // touch screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: scene)
        scene.addPoint(location: location)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // navigate to AR 
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
