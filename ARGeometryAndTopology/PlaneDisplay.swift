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
    var planePoints: [[SCNNode]] = []
    var length = CGFloat(0.002)
    var p = CGFloat.pi
    var tubes: [SCNNode] = []
    var pointCnt: Int
    var curvePoints: [SCNNode] = []
    var line: [SCNNode] = []
    
    init(scene: ARSCNView, pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        width = w
        pieces = pieceCount
        length = l
        height = h
        s = scene
        pointCnt = pieces*3
    }
    
    func add(){
        addPlane()
        addCurvePoint()

    }
    

    
    
    func addPlane(){
        let temp = SCNNode()
        planePoints = Array(repeating: Array(repeating: temp, count: pieces), count: pieces)
        for m in 0...pieces-1 {
            for n in 0...pieces-1 {
                let node = SCNNode()
                let x = CGFloat(n)*width/CGFloat(pieces)-width/2
                let y = CGFloat(m)*height/CGFloat(pieces)+height/2
                node.geometry = SCNSphere(radius: 0.001)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.position = SCNVector3(x,y,0)
                node.opacity = 0.5
                planePoints[m][n] = node
                
            }
            
            
        }
        addTriangle()
    }
    
    func addTriangle(){
        // add line to scene
        for i in 0...(planePoints[0].count-1) {
            for j in 0...(planePoints[0].count-1) {
                var triangle1  = SCNNode()
                var triangle2  = SCNNode()
                if (j != planePoints[0].count-1 && i != planePoints[0].count-1){
                    triangle1 = SCNNode.createTriangleNode(first: planePoints[i][j], second: planePoints[i][j+1],
                                                           third: planePoints[i+1][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: planePoints[i+1][j+1], second: planePoints[i][j+1],
                                                           third: planePoints[i+1][j],
                                                           color: UIColor.white)
                } else if (j == planePoints[0].count-1 && i != planePoints[0].count-1) {
                    triangle1 = SCNNode.createTriangleNode(first: planePoints[i][j], second: planePoints[i][0],
                                                           third: planePoints[i+1][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: planePoints[i+1][0], second: planePoints[i][0],
                                                           third: planePoints[i+1][j],
                                                           color: UIColor.white)
                } else if (j != planePoints[0].count-1 && i == planePoints[0].count-1) {
                    triangle1 = SCNNode.createTriangleNode(first: planePoints[i][j], second: planePoints[i][j+1],
                                                           third: planePoints[0][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: planePoints[0][j+1], second: planePoints[i][j+1],
                                                           third: planePoints[0][j],
                                                           color: UIColor.white)
                } else {
                    triangle1 = SCNNode.createTriangleNode(first: planePoints[i][j], second: planePoints[i][0],
                                                           third: planePoints[0][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: planePoints[0][0], second: planePoints[i][0],
                                                           third: planePoints[0][j],
                                                           color: UIColor.white)
                }
                s.scene.rootNode.addChildNode(triangle1)
                s.scene.rootNode.addChildNode(triangle2)
            }
        }
        
    }
    
    // add curvePoints
    func addCurvePoint(){
        for yP in 0...2 {
            for xP in 0...(pointCnt-1) {
                let p1 = SCNNode()
                p1.geometry = SCNSphere(radius: 0.0005)
                if (yP == 0){
                    p1.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                } else if (yP == 1) {
                    p1.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
                } else {
                    p1.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                }
                let x = CGFloat(xP)*width/CGFloat(pointCnt)-width/2
                let y = CGFloat(yP)*height/CGFloat(6)+height/2+height/4
                p1.position = SCNVector3(x,y,CGFloat(0))
                curvePoints.append(p1)
                s.scene.rootNode.addChildNode(p1)
            }
        }
    }
    
    func addLine(){
        // add line to scene
        for j in 0...(curvePoints.count-1) {
            if (j != curvePoints.count-1){
                let linenode = SCNNode.createLineNode(fromNode: curvePoints[j], toNode: curvePoints[j+1], color: UIColor.black)
                line.append(linenode)
                //                let node = shapePoints[j].parent
                //                node?.addChildNode(linenode)
                s.scene.rootNode.addChildNode(linenode)
            } else {
                //                let linenode = SCNNode.createLineNode(fromNode: shapePoints[j], toNode: shapePoints[0], color: UIColor.black)
                //                line.append(linenode)
                //                //let node = shapePoints[j].parent
                //                //node?.addChildNode(linenode)
                //                s.scene.rootNode.addChildNode(linenode)
            }
            
        }
    }

}
