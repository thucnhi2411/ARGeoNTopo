//
//  TorusWithPoints.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/1/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class TorusWithPoints: NSObject {

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
    var odd = true
    
    init(scene: ARSCNView, radius: CGFloat, pieceCount: Int, h: CGFloat, l: CGFloat){
        s = scene
        r = radius
        pieces = pieceCount
        height = h
        length = l
        w = (2*r*p)/CGFloat(pieces)
        curve = Curve(scene: s, radius: r)
    }
    
    // add everything up
    func add(){
        createPlane()
        transformPlane()
        addLine()
        addToScreen()
        curve.points = points
        curve.line = line
        
    }
    
    // create multiple planes/flat boxes
    func createPlane(){
        for _ in 1...pieces {
            let node = SCNNode()
            node.geometry = SCNBox(width: w, height: height, length: length, chamferRadius: 0)
            //node.geometry = SCNPlane(width: w, height: height)
            //node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            node.opacity = 0.5
            planes.append(node)
        }
        firstQuadrant()
        secondQuadrant()
        thirdQuadrant()
        fourthQuadrant()
        addPoint()
    }
    
    
    // add points
    func addPoint(){
        //0,0,0
        var original_y = -height/2
        let point0 = SCNNode()
        point0.position = SCNVector3(CGFloat(planes[0].position.x),original_y,CGFloat(planes[0].position.z)-length)
        point0.geometry = SCNSphere(radius: 0.001)
        point0.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        points.append(point0)
        planes[0].addChildNode(point0)
        for j in 1...3 {
            for i in 0...pieces-1 {
                let point = SCNNode()
                let node = planes[i]
                original_y = -height/2
                original_y = original_y + CGFloat(j)*height/3
                // not plane's childnode
                if (node.position.z > 0){
                   point.position = SCNVector3(CGFloat(node.position.x),original_y,CGFloat(node.position.z))
                } else {
                    point.position = SCNVector3(CGFloat(node.position.x),original_y,CGFloat(node.position.z))
                }
                
                // plane's childnode
//                if (node.position.z > 0){
//                    point.position = SCNVector3(0,original_y,0+length)
//                } else {
//                    point.position = SCNVector3(0,original_y,0-length)
//                }
                point.geometry = SCNSphere(radius: 0.001)
                point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                points.append(point)
                node.addChildNode(point)
                
            }



        }


    }
    
    // connect points to create curve
    func addLine(){
        print(points)
        // add line to scene
        for j in 0...(points.count-1) {
            if (j != points.count-1){
                let linenode = SCNNode.createLineNode(fromNode: points[j], toNode: points[j+1], color: UIColor.black)
                line.append(linenode)
//                let node = points[j].parent
//                node?.addChildNode(linenode)
                s.scene.rootNode.addChildNode(linenode)
            } else {
//                let linenode = SCNNode.createLineNode(fromNode: points[j], toNode: points[0], color: UIColor.black)
//                line.append(linenode)
//                //let node = points[j].parent
//                //node?.addChildNode(linenode)
//                s.scene.rootNode.addChildNode(linenode)
            }
            
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
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
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
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(-r*x,y,-r*z)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
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
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(-r*x,y,r*z)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
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
            let z = CGFloat(cos(i*p/CGFloat(pieces)))
            node.position = SCNVector3(r*x,y,r*z )
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
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
            node.eulerAngles = SCNVector3(0,-i*p/CGFloat(pieces),0)
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
            node.eulerAngles = SCNVector3(0,i*p/CGFloat(pieces),0)
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
    
    func shorten(){
        if (odd){
            curve.manipulateOdd()
        } else {
            curve.manipulateEven()
        }
        odd = !odd
    }
    
    // add nodes to scene view
    func addToScreen(){
        for i in 0...pieces-1 {
            s.scene.rootNode.addChildNode(planes[i])
        }
        for j in 0...points.count-1 {
            s.scene.rootNode.addChildNode(points[j])
        }
    }
    
    func removeAllElements(){
        planes.removeAll()
        points.removeAll()
        line.removeAll()
    }
    
}







