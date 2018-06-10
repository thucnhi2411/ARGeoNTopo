//
//  PlaneDisplay.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/7/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

/**
 * Display in 2D the plane and the curve
 */
class PlaneDisplay: NSObject {
    var s: ARSCNView
    var height: CGFloat
    var width: CGFloat
    var pieces: Int
    var planes: [SCNNode] = []
    var length = CGFloat(0.002)
    var p = CGFloat.pi
    var r: CGFloat
    
    init(scene: ARSCNView, radius: CGFloat, h: CGFloat, pieceCount: Int){
        s = scene
        r = radius
        height = h //y
        width = 2*r*p  //x
        pieces = pieceCount

    }
    
    func add() {
        createPlane()
        firstQuadrant()
        secondQuadrant()
        thirdQuadrant()
        fourthQuadrant()
        addToScreen()
    }
    
    // create multiple planes/flat boxes
    func createPlane(){
        for _ in 1...pieces {
            let node = SCNNode()
            node.geometry = SCNBox(width: width/CGFloat(pieces), height: height, length: length, chamferRadius: 0)
            //node.geometry = SCNPlane(width: w, height: height)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.opacity = 0.5
            planes.append(node)
        }
    }
    
    // +x, -z
    func firstQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for j in 0...(pieces/4-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(0)
            node.position = SCNVector3(r*x,y,-r*z)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            i = i-2
        }
    }
    // -x, -z
    func secondQuadrant(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in (pieces/4)...(pieces/2-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(0)
            node.position = SCNVector3(-r*x,y,-r*z)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            i = i+2
        }
    }
    // -x, +z
    func thirdQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for j in (pieces/2)...(3*pieces/4-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(0)
            node.position = SCNVector3(-r*x-r,y,r*z)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            i = i-2
        }
    }
    // +x, +z
    func fourthQuadrant(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in (3*pieces/4)...(pieces-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(0)
            node.position = SCNVector3(r*x+r,y,r*z )
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            i = i+2
        }
    }
    
    // add nodes to scene view
    func addToScreen(){
        for i in 0...pieces-1 {
            s.scene.rootNode.addChildNode(planes[i])
        }
    }
    

    
}
