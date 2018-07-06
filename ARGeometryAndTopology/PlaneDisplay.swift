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
    // plane features
    var s: ARSCNView                    // screen
    var height: CGFloat                 // height
    var width: CGFloat                  // width
    var pieces: Int                     // number of peaces
    var planePoints: [[SCNNode]] = []   // number of points creating plane
    var length = CGFloat(0.002)         // thickness
    var xLowerBound = CGFloat()
    var yLowerBound = CGFloat()
    
    // constant
    var p = CGFloat.pi

    // curve features
    var pointCnt: Int                   // number of points
    var curvePoints: [SCNNode] = []     // array of points
    var curvePoints3D: [SCNNode] = []   // for visualization
    var line = SCNNode()                // line node
    var edgePoints: [SCNNode: SCNNode] = [:]    // dict of edge points
    var curve: Curve                    // curve object
    var odd = true                      // control odd/even manipulation
    var leftNode = SCNNode()            // left edge node
    var rightNode = SCNNode()           // right edge node
    var left = false                    // whether leftNode existed
    var right = false                   // whether rightNode existed
    var leftMost = 0
    var rightMost = 0
    
    init(scene: ARSCNView, pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        width = w
        pieces = pieceCount
        length = l
        height = h
        s = scene
        pointCnt = pieces
        xLowerBound = -width/2
        yLowerBound = height/2
        curve = Curve(scene: s, radius: width)
        curve.width = width
        curve.height = height
        curve.xLowerBound = xLowerBound
        curve.yLowerBound = yLowerBound
        
    }
    
    func add(){
        addPlane()
        addPointManually()
        addToScreen()
        addLine()
        curve.points = curvePoints
        curve.edgePoints = edgePoints
        
    }
    

    
    
    func addPlane(){
        let temp = SCNNode()
        planePoints = Array(repeating: Array(repeating: temp, count: pieces+1), count: pieces+1)
        for m in 0...pieces {
            for n in 0...pieces {
                let node = SCNNode()
                let x = xLowerBound + CGFloat(n)*width/CGFloat(pieces)
                let y = yLowerBound + CGFloat(m)*height/CGFloat(pieces)
                node.geometry = SCNSphere(radius: 0.001)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                node.position = SCNVector3(x,y,0)
                node.opacity = 0.5
                planePoints[m][n] = node
                s.scene.rootNode.addChildNode(node)
            }
            
        }
        addTriangle()
    }
    
    func addTriangle(){
        // add line to scene
        for i in 0...(pieces-1) {
            for j in 0...(pieces-1) {
                var triangle1  = SCNNode()
                var triangle2  = SCNNode()
                triangle1 = SCNNode.createTriangleNode(first: planePoints[i][j], second: planePoints[i][j+1],
                                                    third: planePoints[i+1][j], color: UIColor.white)
                triangle2 = SCNNode.createTriangleNode(first: planePoints[i+1][j+1], second: planePoints[i][j+1],
                                                    third: planePoints[i+1][j], color: UIColor.white)
                
                s.scene.rootNode.addChildNode(triangle1)
                s.scene.rootNode.addChildNode(triangle2)
            }
        }
        
    }
    func addPointManually(){
        let x0 = xLowerBound //0
        let y0 = yLowerBound+height/4 //6
        let pA = SCNNode()
        pA.position = SCNVector3(x0,y0,0.001) //0,6
        let pB = SCNNode()
        pB.position = SCNVector3(x0+width/8,y0+height/4,0.001) //2,4
        let pC = SCNNode()
        pC.position = SCNVector3(x0+width/4, y0+height/8, 0.001) //4,5
        let pD = SCNNode()
        pD.position = SCNVector3(x0+5*width/16,y0+height/2, 0.001) //5,2
        let pE = SCNNode()
        pE.position = SCNVector3(x0+width/2, y0+height/4, 0.001) //8,4
        let pF = SCNNode()
        pF.position = SCNVector3(x0+5*width/8, y0+height/4, 0.001) //10,4
        let pG = SCNNode()
        pG.position = SCNVector3(x0+13*width/16, y0+3*height/8, 0.001) //13,3
        let pH = SCNNode()
        pH.position = SCNVector3(x0+width, y0, 0.001) //15,6
        curvePoints.append(pA)
        curvePoints.append(pB)
        curvePoints.append(pC)
        curvePoints.append(pD)
        curvePoints.append(pE)
        curvePoints.append(pF)
        curvePoints.append(pG)
        //curvePoints.append(pH)
        for i in 0...6 {
            let node = curvePoints[i]
            node.geometry = SCNSphere(radius: 0.001)
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            if (node.position.x < curvePoints[leftMost].position.x){
                leftMost = i
            }
            if (node.position.x > curvePoints[rightMost].position.x){
                rightMost = i
            }
            if (CGFloat(node.position.x) == xLowerBound){
                leftNode = node
                left = true
            } else if (CGFloat(node.position.x) == width+xLowerBound) {
                rightNode = node
                right = true
            }
        }

        addEdgeNode()
        visualizeFunc()
        addToScreen()
    }
   
    func addEdgeNode(){
        if (!left && right){
            curvePoints.insert(addExtraPoint(original_p: rightNode), at: leftMost)
            rightMost = rightMost + 1
        } else if (left && !right){
            curvePoints.insert(addExtraPoint(original_p: leftNode), at: rightMost+1)
            rightMost = rightMost + 1
        } else if (!left && !right){
            curvePoints.insert(addAdditionalEdgeNode()[0], at: leftMost)
            curvePoints.insert(addAdditionalEdgeNode()[1], at: rightMost+2)
            rightMost = rightMost+2
        }
    }
    
    func addAdditionalEdgeNode()->[SCNNode]{
        let right = SCNNode()
        let temp = SCNNode()
        temp.position = SCNVector3(CGFloat(curvePoints[leftMost].position.x) + width,
                         CGFloat(curvePoints[leftMost].position.y),CGFloat(curvePoints[leftMost].position.z))
        let b = CGFloat(temp.position.x - curvePoints[rightMost].position.x)
        let a = CGFloat(-(temp.position.y - curvePoints[rightMost].position.y))
        let x = width+xLowerBound
        let x0 = CGFloat(temp.position.x)
        let y0 = CGFloat(temp.position.y)
        let y = (-a * (x-x0))/b + y0
        right.position = SCNVector3(x,y,CGFloat(temp.position.z))
        right.name = "rightSide"
        right.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        right.geometry = SCNSphere(radius: 0.001)
        let left = SCNNode()
        left.position = SCNVector3(xLowerBound,y,CGFloat(temp.position.z))
        left.name = "leftSide"
        left.geometry = SCNSphere(radius: 0.001)
        left.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        var arr: [SCNNode] = []
        arr.append(left)
        arr.append(right)
        return arr
        

    }
    
    func visualizeFunc(){
        curvePoints3D = curvePoints
        var offset = 0
        for i in 0...curvePoints.count-1 {
            if (i != curvePoints.count-1){
                var additionalPoints = pointsInInterval(nodeA: curvePoints[i], nodeB: curvePoints[i+1])
                if (!additionalPoints.isEmpty) {
                    for j in 0...additionalPoints.count-1 {
                        curvePoints3D.insert(additionalPoints[j], at: i+j+1+offset)
                    }
                }
                offset = offset + additionalPoints.count
            } else {
                var additionalPoints = pointsInInterval(nodeA: curvePoints[i], nodeB: curvePoints[0])
                if (!additionalPoints.isEmpty) {
                    for j in 0...additionalPoints.count-1 {
                        curvePoints3D.insert(additionalPoints[j], at: i+j+1+offset)
                    }
                }
                offset = offset + additionalPoints.count

            }
            
        }
        

    }
    
    func pointsInInterval(nodeA: SCNNode, nodeB: SCNNode)->[SCNNode]{
        var arr: [SCNNode] = []
        let b = CGFloat(nodeA.position.x - nodeB.position.x)
        let a = CGFloat(-(nodeA.position.y - nodeB.position.y))
        let x0 = CGFloat(nodeA.position.x)
        let y0 = CGFloat(nodeA.position.y)
        var i = width/(3*CGFloat(pieces))
        while (i < abs(b)){
            
            let x = x0 + i
            if (x <= xLowerBound+width && x >= xLowerBound){
                let y = (-a * (x-x0))/b + y0
                let node = SCNNode()
                node.position = SCNVector3(x,y,CGFloat(nodeA.position.z))
                arr.append(node)
                
            }
            i = i+width/(3*CGFloat(pieces))
            

        }
        return arr
        
    }

    
    func addExtraPoint(original_p: SCNNode)->SCNNode{
        let x = CGFloat(original_p.position.x)
        let y = CGFloat(original_p.position.y)
        let point = SCNNode()
        point.geometry = SCNSphere(radius: 0.001)
        if (x == xLowerBound){
            point.position = SCNVector3(xLowerBound+width,y,0.001)
            point.name = "rightSide"
        } else if (x == xLowerBound+width){
            point.position = SCNVector3(xLowerBound,y,0.001)
            point.name = "leftSide"
        }
        
        if (y == yLowerBound){
            point.position = SCNVector3(x,yLowerBound+height,0.001)
            point.name = "top"
        } else if (y == yLowerBound+height){
            point.position = SCNVector3(x,yLowerBound,0.001)
            point.name = "bottom"
        }
        if (point.name == "leftSide") {
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        } else if (point.name == "rightSide") {
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        }
        edgePoints.updateValue(point, forKey: original_p)
        edgePoints.updateValue(original_p, forKey: point)
        return point
        
    }
    func addLine() {
        line.name = "line"
        // add line to scene
        for j in 0...(curvePoints.count-1) {
            let x = curvePoints[j].position.x
            let y = curvePoints[j].position.y
            if (j != curvePoints.count-1){

                let x1 = curvePoints[j+1].position.x
                let y1 = curvePoints[j+1].position.y
                if (CGFloat(x) != xLowerBound+width && CGFloat(x1) != xLowerBound
                && CGFloat(y) != yLowerBound+height && CGFloat(y1) != yLowerBound){
                    let linenode = SCNNode.createLineNode(fromNode: curvePoints[j], toNode: curvePoints[j+1], color: UIColor.black)
                    line.addChildNode(linenode)
                }

            } else {
                let x1 = curvePoints[0].position.x
                let y1 = curvePoints[0].position.y
                if (CGFloat(x) != xLowerBound+width && CGFloat(x1) != xLowerBound
                    && CGFloat(y) != yLowerBound+height && CGFloat(y1) != yLowerBound){
                    let linenode = SCNNode.createLineNode(fromNode: curvePoints[j], toNode: curvePoints[0], color: UIColor.black)
                    line.addChildNode(linenode)
                   
                }
            }
            
        }
        s.scene.rootNode.addChildNode(line)
    }
    
    
    func addToScreen(){
        for i in 0...curvePoints.count-1{
            s.scene.rootNode.addChildNode(curvePoints[i])
        }
    }
    
    func indexOfLine() -> Int{
        let arr = s.scene.rootNode.childNodes
        return arr.index(of: line)!
    }
    
    func shorten(){
        if (odd){
            curve.manipulateOdd()
        } else {
            curve.manipulateEven()
        }
        s.scene.rootNode.childNodes[indexOfLine()].removeFromParentNode()
        while (!line.childNodes.isEmpty){
           line.childNodes[0].removeFromParentNode()
        }
        curvePoints3D.removeAll()
        visualizeFunc()
        addLine()
        odd = !odd
    }

}
