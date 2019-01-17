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


    var s: ARSCNView                        // scene
    var points: [SCNNode]=[]                // array of curve points
    var r: CGFloat                          // radius
    var edgePoints: [SCNNode: SCNNode] = [:]    // edge points dict
    var height = CGFloat()                  // height of the plane
    var width = CGFloat()                   // width of the plane
    var xLowerBound = CGFloat()             // xLowerBound of plane
    var yLowerBound = CGFloat()             // yLowerBound of plane
    
    // direction same as Plane Display class
    var horizontally = false
    var vertically = false
    var h_left = false
    var h_right = false
    var v_top = false
    var v_bottom = false
    
    // initialize
    init(scene: ARSCNView, radius: CGFloat){
        s = scene
        r = radius
    }
    

    // point 0,2,4,...
    func manipulateEven(){
        if (points.count-2 > 0){
            for i in 0...(points.count-2) {
                if (i%2 == 0){
                    print(i)
                    if (i < points.count-2){
                        print("normal")
                        updateCurve(p1: points[i], p2: points[i+1], p3: points[i+2])
                        
                    } else {
                        print("exception")
                        updateException(p1: points[i], p2: points[i+1], p3: points[0], p4: points[1])
                        
                        
                    }
                }
                resetName()
            }
        }

    }

    // point 1,3,5,...
    func manipulateOdd(){
        if (points.count-2 > 0){
            for i in 1...(points.count-2) {
                if (i%2 != 0){
                    print(i)
                    if (i < points.count-2){
                        print("normal")
                        updateCurve(p1: points[i], p2: points[i+1], p3: points[i+2])
                    } else {
                        print("exception")
                        updateException(p1: points[i], p2: points[i+1], p3: points[0], p4: points[1])
                    }
                }
                resetName()
            }
        }

   
    }
    
    // handling normal nodes
    func updateCurve(p1: SCNNode, p2: SCNNode, p3: SCNNode){
        let nodeA = p1.position
        let nodeB = p2.position
        let nodeC = p3.position

        if (dist(loc1: nodeA,loc2: nodeC) <
            dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
            let newPos = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
            p2.position = newPos

            if (edgePoints[p2] != nil){
                let temp = edgePoints[p2]
                if (horizontally){
                    temp?.position = SCNVector3((temp?.position.x)!, newPos.y, newPos.z)
                }
                if (vertically){
                    temp?.position = SCNVector3(newPos.x, (temp?.position.y)!, newPos.z)
                }
                
            }

        }
    }
    
    // when handling the edges node
    func updateException(p1: SCNNode, p2: SCNNode, p3: SCNNode, p4: SCNNode){
        let nodeA = p1.position
        let nodeC = p3.position
        let nodeD = p4.position
        let temp = SCNNode()
        if (horizontally){
            if (h_left){
                temp.position = SCNVector3(CGFloat(nodeA.x)-width,CGFloat(nodeA.y), CGFloat(nodeA.z))
            }
            if (h_right){
                temp.position = SCNVector3(CGFloat(nodeA.x)+width,CGFloat(nodeA.y), CGFloat(nodeA.z))
            }
            
        }
        if (vertically){
            if (v_bottom){
                temp.position = SCNVector3(CGFloat(nodeA.x),CGFloat(nodeA.y)-height, CGFloat(nodeA.z))
            }
            if (v_top){
                temp.position = SCNVector3(CGFloat(nodeA.x),CGFloat(nodeA.y)+height, CGFloat(nodeA.z))
            }
            
        }
        if (dist(loc1: temp.position,loc2: nodeD) <
            dist(loc1: temp.position,loc2: nodeC)+dist(loc1: nodeC, loc2: nodeD)) {
            let newPos = calculateNewLoc(nodeA: temp.position, nodeB: nodeC, nodeC: nodeD)
            p3.position = newPos

            if (horizontally){
                if (newPos.x != Float(xLowerBound)){
                    points.remove(at: points.count-1)
                } else {
                    if (h_left){
                        p2.position = SCNVector3(CGFloat(nodeC.x)+width, CGFloat(newPos.y), CGFloat(newPos.z))
                    }
                    if (h_right){
                        p2.position = SCNVector3(CGFloat(nodeC.x)-width, CGFloat(newPos.y), CGFloat(newPos.z))
                    }
                    
                }
            }
            if (vertically){
                if (newPos.y != Float(yLowerBound)){
                    points.remove(at: points.count-1)
                } else {
                    if (v_bottom){
                        p2.position = SCNVector3(CGFloat(newPos.x), CGFloat(nodeC.y)+height, CGFloat(newPos.z))
                    }
                    if (v_top){
                        p2.position = SCNVector3(CGFloat(newPos.x), CGFloat(nodeC.y)-height, CGFloat(newPos.z))
                    }
                    
                }
            }
            

        }
    }
    
    // reset name of all nodes
    func resetName(){
        for i in 0...points.count-1{
            points[i].name = nil
        }
    }
    
    //   B
    //  / \    ====>
    // A - C            A-B-C
    
    func calculateNewLoc(nodeA: SCNVector3, nodeB:SCNVector3, nodeC:SCNVector3) -> SCNVector3{

        // write parametrized system for the line
        let u = SCNVector3(nodeC.x-nodeA.x,
                          nodeC.y-nodeA.y,
                          nodeC.z-nodeA.z) //vector AC
        // system:
        // x = nodeA.x-u.x*t = xH
        // y = nodeA.y-u.y*t = yH
        // z = nodeA.z-u.z*t = zH
        // BH*u = 0
        // (xH-nodeB.x)*u.x + (yH-nodeB.y)*u.y + (zH-nodeB.z)*u.z = 0
        var t = (nodeA.x-nodeB.x)*u.x + (nodeA.y-nodeB.y)*u.y + (nodeA.z-nodeB.z)*u.z
        t = t/(pow(u.x,2)+pow(u.y,2)+pow(u.z,2))
        var newX = CGFloat(nodeA.x-u.x*t)
        let newY = CGFloat(nodeA.y-u.y*t)
        var newZ = CGFloat(nodeA.z-u.z*t)
        // restriction to make sure points stay on the torus
        if (pow(newX,2)+pow(newZ,2)<pow(r,2)){
            newX = CGFloat(nodeB.x)
            newZ = CGFloat(nodeB.z)
        }
        let newLoc = SCNVector3(newX,newY,newZ)
        return newLoc
    }
    
    // calculating distance between two points
    func dist(loc1: SCNVector3, loc2: SCNVector3)->CGFloat{
        let x = pow(loc2.x-loc1.x,2)
        let y = pow(loc2.y-loc1.y,2)
        let z = pow(loc2.z-loc1.z,2)
        return CGFloat(sqrt(x+y+z))
    }

    // remove all points
    func removeAllElements(){
        points.removeAll()
    }
}

extension SCNNode {
    static func createLineNode(fromNode: SCNNode, toNode: SCNNode, color: UIColor) -> SCNNode {
        let line = lineFrom(vector: fromNode.position, toVector: toNode.position)
        let lineNode = SCNNode(geometry: line)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        line.materials = [planeMaterial]
        return lineNode
    }
    
    static func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3)-> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}



