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


    var s: ARSCNView
    var points: [SCNNode]=[]
    var line: [SCNNode] = []
    var r: CGFloat

    
    init(scene: ARSCNView, radius: CGFloat){
        s = scene
        r = radius
    }
    
    
    func createBall(hitPosition : SCNVector3) {
        let point0 = SCNNode()
        point0.position = hitPosition
        point0.geometry = SCNSphere(radius: 0.05)
        point0.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        points.append(point0)
        s.scene.rootNode.addChildNode(point0)
        //connectLine()
    }
    
    func connectLine(){
        if (points.count > 0){
            let linenode = SCNNode.createLineNode(fromNode: points[points.count-1], toNode: points[points.count-2], color: UIColor.black)
            s.scene.rootNode.addChildNode(linenode)
            line.append(linenode)
        }
    }

    
    // point 0,2,4,...
    func manipulateEven(){
        for i in 0...(points.count-2) {
            if (i%2 == 0){
             
                if (i != points.count-2){
                     let nodeA = points[i].position
                     let nodeB = points[i+1].position
                     let nodeC = points[i+2].position
                    
                    if (dist(loc1: nodeA,loc2: nodeC) <
                        dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
                        let newPos = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
                        //if (dist(loc1: newPos, loc2: SCNVector3(0,0,0)) >= r){
                            points[i+1].position = newPos
                            var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
                            s.scene.rootNode.replaceChildNode(line[i], with: temp)
                            line[i] = temp
                            temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[i+2], color: UIColor.black)
                            s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
                            line[i+1] = temp
                        //}

                    }
                    
                } else {
//                     let nodeA = points[i].position
//                     let nodeB = points[i+1].position
//                     let nodeC = points[0].position
//
//
//                    if (dist(loc1: nodeA,loc2: nodeC) <
//                        dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
//                        points[i+1].position = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
//                        var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
//                        s.scene.rootNode.replaceChildNode(line[i], with: temp)
//                        line[i] = temp
//                        temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[0], color: UIColor.black)
//                        s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
//                        line[i+1] = temp
//                    }
                }

            }
        }

    }
    
    // point 1,3,5,...
    func manipulateOdd(){
        for i in 1...(points.count-2) {
            if (i%2 != 0){
               
                if (i != points.count-2){
                   
                    let nodeA = points[i].position
                    let nodeB = points[i+1].position
                    let nodeC = points[i+2].position
                    
                    if (dist(loc1: nodeA,loc2: nodeC) <
                        dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
                        let newPos = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
                        //if (dist(loc1: newPos, loc2: SCNVector3(0,0,0)) >= r){
                            points[i+1].position = newPos
                            var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
                            s.scene.rootNode.replaceChildNode(line[i], with: temp)
                            line[i] = temp
                            temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[i+2], color: UIColor.black)
                            s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
                            line[i+1] = temp
                        //}
                    }
                    
                } else {
//                    let nodeA = points[i].position
//                    let nodeB = points[i+1].position
//                    let nodeC = points[0].position
//
//
//                    if (dist(loc1: nodeA,loc2: nodeC) <
//                        dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
//                        points[i+1].position = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
//                        var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
//                        s.scene.rootNode.replaceChildNode(line[i], with: temp)
//                        line[i] = temp
//                        temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[0], color: UIColor.black)
//                        s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
//                        line[i+1] = temp
//                    }
                }
            }
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
    
    func dist(loc1: SCNVector3, loc2: SCNVector3)->CGFloat{
        let x = pow(loc2.x-loc1.x,2)
        let y = pow(loc2.y-loc1.y,2)
        let z = pow(loc2.z-loc1.z,2)
        return CGFloat(sqrt(x+y+z))
    }

    func removeAllElements(){
        points.removeAll()
        line.removeAll()
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

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


