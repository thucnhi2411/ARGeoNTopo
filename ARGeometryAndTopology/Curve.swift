//
//  Curve.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 5/23/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Curve: NSObject {

    var r = CGFloat()
    var pieces: Int
    var height = CGFloat()
    var p = CGFloat.pi //3.14
    var w = CGFloat() //width
    var length = CGFloat()
    var thickness = CGFloat()
    var s: ARSCNView
    init(scene: ARSCNView, radius: CGFloat, pieceCount: Int, h: CGFloat, l: CGFloat, thick: CGFloat){
        r = radius
        pieces = pieceCount
        height = h
        length = l
        w = (2*r*p)/CGFloat(pieces)
        s = scene
        thickness = thick
        
    }
    
    func add(){
        firstQuadrant()
        secondQuadrant()
        thirdQuadrant()
        fourthQuadrant()
    }
    
    func fourthQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        
        for _ in 1...pieces/4 {
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            drawLine(x: (r+length/2)*x, y: y, z: (r+length/2)*z , trans: i*p/CGFloat(pieces))
            i = i-2
        }
    }
    
    func firstQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            drawLine(x: (r+length/2)*x, y: y, z: -(r+length/2)*z , trans: -i*p/CGFloat(pieces))
            i = i-2
        }
    }
    
    func thirdQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            drawLine(x: -(r+length/2)*x, y: y, z: (r+length/2)*z , trans: -i*p/CGFloat(pieces))
            i = i-2
        }
    }
    
    func secondQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(0)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            drawLine(x: -(r+length/2)*x, y: y, z: -(r+length/2)*z , trans: i*p/CGFloat(pieces))
            i = i-2
        }
    }
    
    func drawLine(x:CGFloat,y:CGFloat,z:CGFloat,trans: CGFloat){
        let node = SCNNode()
        node.geometry = SCNBox(width: w, height: height, length: thickness, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        node.position = SCNVector3(x,y,z)
        node.eulerAngles = SCNVector3(0,trans,0)
        s.scene.rootNode.addChildNode(node)
    }
    
    
    
}
