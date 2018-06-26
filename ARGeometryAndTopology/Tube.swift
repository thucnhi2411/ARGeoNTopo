//
//  Tube.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/9/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Tube: NSObject {
    var r = CGFloat()
    var pieces: Int
    var p = CGFloat.pi //3.14
    var s: ARSCNView
    var planes: [SCNNode] = []
    init(scene: ARSCNView, pieceCount: Int, perimeter: CGFloat, planeArr: [SCNNode]){
        r = perimeter/(2*p)
        pieces = pieceCount
        s = scene
        planes = planeArr
    }
    
    func add(){
        firstQuadrant()
        secondQuadrant()
        thirdQuadrant()
        fourthQuadrant()
        transformPlane()
        addToScreen()
    }
    
    
    // +x, -z
    func firstQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
     
        for j in 0...(pieces/4-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(node.position.y)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(r*x,y,-r*z)
            i = i-2
            
        }
    }
    // -x, -z
    func fourthQuadrant(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in pieces/4...pieces/2-1 {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(node.position.y)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(-r*x,y,-r*z)
            i = i+2
        }
    }
    // -x, +z
    func thirdQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for j in pieces/2...(3*pieces/4-1) {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(node.position.y)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(-r*x,y,r*z)
            i = i-2
        }
    }
    // +x, +z
    func secondQuadrant(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in 3*pieces/4...pieces-1  {
            let node = planes[j]
            let x = CGFloat(sin(i*p/CGFloat(pieces)))
            let y = CGFloat(node.position.y)
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(r*x,y,r*z )
            i = i+2
            
        }
    }
    // transform into torus
    func transformPlane(){
        transformFirst()
        transformSecond()
        transformThird()
        transformFourth()
        
    }
    // transform 1st quadrant
    func transformFirst(){
        var i = CGFloat(pieces/2)
        i = i-1
        for j in 0...(pieces/4-1) {
            let node = planes[j]
            node.eulerAngles = SCNVector3(0,-i*p/CGFloat(pieces)-p,0)
            i = i-2
        }
    }
    // transform 2nd quadrant
    func transformSecond(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in pieces/4...pieces/2-1 {
            let node = planes[j]
            node.eulerAngles = SCNVector3(0,i*p/CGFloat(pieces)+p,0)
            i = i+2
        }
    }
    // transform 3rd quadrant
    func transformThird(){
        var i = CGFloat(pieces/2)
        i = i-1
        for j in pieces/2...(3*pieces/4-1) {
            let node = planes[j]
            node.eulerAngles = SCNVector3(0,-i*p/CGFloat(pieces),0)
            i = i-2
        }
    }
    // transform 4th quadrant
    func transformFourth(){
        //        var i = CGFloat(pieces/2)
        //        i = i-1
        var i = CGFloat(1)
        for j in 3*pieces/4...pieces-1 {
            let node = planes[j]
            node.eulerAngles = SCNVector3(0,i*p/CGFloat(pieces),0)
            i = i+2
        }
    }

    
    func addToScreen(){
        for i in 0...pieces-1 {
            s.scene.rootNode.addChildNode(planes[i])
        }
    }
}

