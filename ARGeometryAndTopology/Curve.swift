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

    
    init(scene: ARSCNView){
        s = scene
    }
    
    func add(){
        let p0 = SCNNode()
        p0.position = SCNVector3(0.01,0,0)
        let p1 = SCNNode()
        p1.position = SCNVector3(0.02,0.04,0.03)
        let p2 = SCNNode()
        p2.position = SCNVector3(0.05,0.02,0.05)
        let p3 = SCNNode()
        p3.position = SCNVector3(0.06,0.06,0)
        let p4 = SCNNode()
        p4.position = SCNVector3(0.09,0.05,0.07)
        let p5 = SCNNode()
        p5.position = SCNVector3(0.11,0.03,0.1)
        let p6 = SCNNode()
        p6.position = SCNVector3(0.13,0.02,0.08)
        let p7 = SCNNode()
        p7.position = SCNVector3(0.15,0.04,0.06)
        
        
        points.append(p0) //0
        points.append(p1)
        points.append(p2)
        points.append(p3)
        points.append(p4)
        points.append(p5)
        points.append(p6)
        points.append(p7) //7
        for i in 0...(points.count-1) {
            points[i].geometry = SCNSphere(radius: 0.001)
            points[i].geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            s.scene.rootNode.addChildNode(points[i])
        }
        for j in 0...(points.count-2) {
            let linenode = SCNNode.createLineNode(fromNode: points[j], toNode: points[j+1], color: UIColor.black)
            s.scene.rootNode.addChildNode(linenode)
            line.append(linenode)
        }
        print(points)

    }
    
    func manipulateEven(){
        for i in 0...(points.count-3) {
            if (i%2 == 0){
                let nodeA = points[i].position
                let nodeB = points[i+1].position
                let nodeC = points[i+2].position
                if (dist(loc1: nodeA,loc2: nodeC) <
                    dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
                    points[i+1].position = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
                    var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
                    s.scene.rootNode.replaceChildNode(line[i], with: temp)
                    line[i] = temp
                    temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[i+2], color: UIColor.black)
                    s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
                    line[i+1] = temp
                }
            }
        }
        print(points)
    }
    
    func manipulateOdd(){
        for i in 1...(points.count-3) {
            if (i%2 != 0){
                let nodeA = points[i].position
                let nodeB = points[i+1].position
                let nodeC = points[i+2].position
                if (dist(loc1: nodeA,loc2: nodeC) <
                    dist(loc1: nodeA,loc2: nodeB)+dist(loc1: nodeB, loc2: nodeC)) {
                    
                   
                    points[i+1].position = calculateNewLoc(nodeA: nodeA, nodeB: nodeB, nodeC: nodeC)
                    var temp = SCNNode.createLineNode(fromNode: points[i], toNode: points[i+1], color: UIColor.black)
                    s.scene.rootNode.replaceChildNode(line[i], with: temp)
                    line[i] = temp
                    temp = SCNNode.createLineNode(fromNode: points[i+1], toNode: points[i+2], color: UIColor.black)
                    s.scene.rootNode.replaceChildNode(line[i+1], with: temp)
                    line[i+1] = temp
                }
            }
        }
        print(points)
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
        let newX = CGFloat(nodeA.x-u.x*t)
        let newY = CGFloat(nodeA.y-u.y*t)
        let newZ = CGFloat(nodeA.z-u.z*t)
        let newLoc = SCNVector3(newX,newY,newZ)
        return newLoc
    }
    
    func dist(loc1: SCNVector3, loc2: SCNVector3)->CGFloat{
        let x = pow(loc2.x-loc1.x,2)
        let y = pow(loc2.y-loc1.y,2)
        let z = pow(loc2.z-loc1.z,2)
        return CGFloat(sqrt(x+y+z))
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

