//
//  TorusWithCurve.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/5/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class TorusWithCurve: NSObject {

    var r = CGFloat()
    var pieces: Int
    var height = CGFloat()
    var p = CGFloat.pi //3.14
    var w = CGFloat() //width
    var length = CGFloat()
    var s: ARSCNView
    var planes: [SCNNode] = []
    var points: [SCNNode] = []
    var line: [SCNNode] = []
    var curve: Curve
    
    init(scene: ARSCNView, radius: CGFloat, pieceCount: Int, h: CGFloat, l: CGFloat){
        r = radius
        pieces = pieceCount
        height = h
        length = l
        w = (2*r*p)/CGFloat(pieces)
        s = scene
        curve = Curve(scene: s)
    }
    
    func add(){
        createPlane()
        addToScreen()
    }
    
    // create multiple planes/flat boxes
    func createPlane(){
        for _ in 1...pieces {
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            //node.geometry = SCNPlane(width: w, height: height)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.opacity = 0.9

            planes.append(node)
        }
        fourthQuadrant()
        addPoint()
    }
    
    // add points
    func addPoint(){
        //0,0,0
        //var original_y = CGFloat(planes[7].position.y)-height/2
        //for j in 1...3 {
        for i in 0...pieces-1 {
            let point = SCNNode()
            let node = planes[i]
            //original_y = CGFloat(planes[0].position.y)-height/2
            //original_y = original_y + CGFloat(j)*height/3
            point.position = SCNVector3(CGFloat(CGFloat(node.position.x)), CGFloat(node.position.y), CGFloat(CGFloat(node.position.z)+length/2))
            point.geometry = SCNSphere(radius: 0.001)
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            points.append(point)
            node.addChildNode(point)
            print(point.position)
        }
        
        
        
        //}
        
        
    }
    
    // +x, +z
    func fourthQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        
        for j in (3*pieces/4)...(pieces-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(CGFloat(j)*0.01,y,CGFloat(j)*0.01 )
            //node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            i = i-2
        }
    }
    
    // add nodes to scene view
    func addToScreen(){
        for i in (3*pieces/4)...(pieces-1) {
            s.scene.rootNode.addChildNode(planes[i])
        }
    }
    
}
