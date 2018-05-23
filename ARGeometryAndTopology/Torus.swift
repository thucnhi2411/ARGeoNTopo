//
//  Torus.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 5/23/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Torus: NSObject {
    var r = CGFloat()
    var pieces: Int
    var height = CGFloat()
    var p = CGFloat.pi //3.14
    var w = CGFloat() //width
    var length = CGFloat()
    var s: ARSCNView
    init(scene: ARSCNView, radius: CGFloat, pieceCount: Int, h: CGFloat, l: CGFloat){
        r = radius
        pieces = pieceCount
        height = h
        length = l
        w = (2*r*p)/CGFloat(pieces)
        s = scene
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
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.position = SCNVector3(r*CGFloat(sin(i*p/CGFloat(pieces))),0,r*CGFloat(cos(i*p/CGFloat(pieces))))
            node.eulerAngles = SCNVector3(0,i*p/CGFloat(pieces),0)
            s.scene.rootNode.addChildNode(node)
            i = i-2
        }
    }
    
    func firstQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.position = SCNVector3(r*CGFloat(sin(i*p/CGFloat(pieces))),0,-r*CGFloat(cos(i*p/CGFloat(pieces))))
            node.eulerAngles = SCNVector3(0,-i*p/CGFloat(pieces),0)
            s.scene.rootNode.addChildNode(node)
            i = i-2
        }
    }
    
    func thirdQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.position = SCNVector3(-r*CGFloat(sin(i*p/CGFloat(pieces))),0,r*CGFloat(cos(i*p/CGFloat(pieces))))
            node.eulerAngles = SCNVector3(0,-i*p/CGFloat(pieces),0)
            s.scene.rootNode.addChildNode(node)
            i = i-2
        }
    }
    
    func secondQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.position = SCNVector3(-r*CGFloat(sin(i*p/CGFloat(pieces))),0,-r*CGFloat(cos(i*p/CGFloat(pieces))))
            node.eulerAngles = SCNVector3(0,i*p/CGFloat(pieces),0)
            s.scene.rootNode.addChildNode(node)
            i = i-2
        }
    }
    
}
