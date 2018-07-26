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
    var line = SCNNode()
    var curvePointNode = SCNNode()
    var curve: Curve                    // curve object
    var odd = false                      // control odd/even manipulation
    
    // edges
    var horizontally = false
    var h_left = false        // horizontal starting from the left
    var h_right = false
    var vertically = true
    var v_bottom = false        // vertical starting from the bottom
    var v_top = true
    
    var leftNode = SCNNode()            // left edge node
    var rightNode = SCNNode()           // right edge node
    var left = false                    // whether leftNode existed
    var right = false                   // whether rightNode existed
    var leftMost = 0
    var rightMost = 0
    var topNode = SCNNode()            // top edge node
    var bottomNode = SCNNode()           // bottom edge node
    var top = false                    // whether topNode existed
    var bottom = false                   // whether bottomNode existed
    var topMost = 0
    var bottomMost = 0
    var edgePoints: [SCNNode: SCNNode] = [:]    // dict of edge points
    
    // mode
    var touch = true
    var currentCurve = SCNNode()
    
    init(scene: ARSCNView, pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        width = w
        pieces = pieceCount
        length = l
        height = h
        s = scene
        pointCnt = pieces
        xLowerBound = -width/2
        yLowerBound = -height/2
        curve = Curve(scene: s, radius: width)
        curve.width = width
        curve.height = height
        curve.xLowerBound = xLowerBound
        curve.yLowerBound = yLowerBound
        curve.vertically = vertically
        curve.horizontally = horizontally
        curve.h_left = h_left
        curve.h_right = h_right
        curve.v_top = v_top
        curve.v_bottom = v_bottom
    }
    
    func initPlane(){
        addPlane()
    }
    func add(){
        if (!touch){
            if (horizontally){
                addPointManually()
            }
            if (vertically && !touch){
                addPointManually2()
            }
        }
        if (curvePoints.count != 0) {
            setUpCurvePoints()
            addToScreen()
            addLine()
            curve.points = curvePoints
            curve.edgePoints = edgePoints
        }
        print(curvePoints)
        
    }
    

    // Create the plane
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
    
    // Add points for curve
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
        //curvePoints.append(pA)
        curvePoints.append(pB)
        curvePoints.append(pC)
        curvePoints.append(pD)
        curvePoints.append(pE)
        curvePoints.append(pF)
        curvePoints.append(pG)
        //curvePoints.append(pH)
        setUpCurvePoints()
    }
    
    // Add points for curve
    func addPointManually2(){
        let x0 = xLowerBound + width/4 //0
        let y0 = yLowerBound //0
        let pA = SCNNode()
        pA.position = SCNVector3(x0,y0,0.001) //0,6
        let pB = SCNNode()
        pB.position = SCNVector3(x0+width/4,y0+height/8,0.001) //2,4
        let pC = SCNNode()
        pC.position = SCNVector3(x0+width/8, y0+height/4, 0.001) //4,5
        let pD = SCNNode()
        pD.position = SCNVector3(x0+width/2,y0+5*height/16, 0.001) //5,2
        let pE = SCNNode()
        pE.position = SCNVector3(x0+width/4, y0+height/2, 0.001) //8,4
        let pF = SCNNode()
        pF.position = SCNVector3(x0+width/4, y0+5*height/8, 0.001) //10,4
        let pG = SCNNode()
        pG.position = SCNVector3(x0+3*width/8, y0+13*height/16, 0.001) //13,3
        let pH = SCNNode()
        pH.position = SCNVector3(x0, y0+height, 0.001) //15,6
        curvePoints.append(pA)
        curvePoints.append(pB)
        curvePoints.append(pC)
        curvePoints.append(pD)
        curvePoints.append(pE)
        curvePoints.append(pF)
        curvePoints.append(pG)
        //curvePoints.append(pH)
        setUpCurvePoints()
    }
    
    func setUpCurvePoints(){
        for i in 0...curvePoints.count-1 {
            checkEdge(node: curvePoints[i], index: i)
        }
        
        addEdgeNode()
        visualizeFunc()
        addLine()
        addToScreen()
    }
    
    // mark the left/right/top/bottom most points
    func checkEdge(node: SCNNode, index: Int){
        
        if (horizontally){
            if (node.position.x < curvePoints[leftMost].position.x){
                leftMost = index
            }
            if (node.position.x > curvePoints[rightMost].position.x){
                rightMost = index
            }
            if (CGFloat(node.position.x) == xLowerBound){
                leftNode = node
                node.name = "leftSide"
                left = true
            } else if (CGFloat(node.position.x) == width+xLowerBound) {
                rightNode = node
                node.name = "rightSide"
                right = true
            }
        }

        
        if (vertically){
            
            if (node.position.y < curvePoints[bottomMost].position.y){
                bottomMost = index
            }
            if (node.position.y > curvePoints[topMost].position.y){
                topMost = index
            }
            if (node.position.y == Float(yLowerBound) || CGFloat(node.position.y) == yLowerBound){
                bottomNode = node
                node.name = "bottomSide"
                bottom = true
            } else if (node.position.y == Float(height+yLowerBound) || CGFloat(node.position.y) == height+yLowerBound) {
                topNode = node
                node.name = "topSide"
                top = true
            }
        }

    }
   
    // Add edge node
    func addEdgeNode(){
        if (horizontally){
            if (!left && right){
                print("No left + existing right")
                if (h_left){
                    curvePoints.insert(addExtraPoint(original_p: rightNode), at: leftMost)
                    rightMost = rightMost + 1
                }
                if (h_right){
                    curvePoints.insert(addExtraPoint(original_p: rightNode), at: leftMost+1)
                    leftMost = leftMost + 1
                }
            } else if (left && !right){
                print("Existing left + no right")
                if (h_left){
                    curvePoints.insert(addExtraPoint(original_p: leftNode), at: rightMost+1)
                    rightMost = rightMost + 1
                }
                if (h_right){
                    curvePoints.insert(addExtraPoint(original_p: leftNode), at: rightMost)
                    leftMost = leftMost + 1
                }
                
            } else if (!left && !right){
                print("No left + no right")
                if (h_left){
                    curvePoints.insert(addAdditionalEdgeNode()[0], at: leftMost)
                    curvePoints.insert(addAdditionalEdgeNode()[1], at: rightMost+2)
                    rightMost = rightMost+2
                }
                if (h_right){
                    curvePoints.insert(addAdditionalEdgeNode()[1], at: rightMost)
                    curvePoints.insert(addAdditionalEdgeNode()[0], at: leftMost+2)
                    leftMost = leftMost+2
                }
                
            }
        }
        if (vertically){
            if (!top && bottom){
                print("No top + existing bottom")
                if (v_bottom){
                    curvePoints.insert(addExtraPoint(original_p: bottomNode), at: topMost+1)
                    topMost = topMost + 1
                }
                if (v_top){
                    curvePoints.insert(addExtraPoint(original_p: bottomNode), at: topMost)
                    bottomMost = bottomMost + 1
                }
                
            } else if (top && !bottom){
                print("Existing top + no bottom")
                if (v_bottom){
                    curvePoints.insert(addExtraPoint(original_p: topNode), at: bottomMost)
                    topMost = topMost + 1
                }
                if (v_top){
                    curvePoints.insert(addExtraPoint(original_p: topNode), at: bottomMost+1)
                    bottomMost = bottomMost + 1
                }
                
            } else if (!top && !bottom){
                print("No top + no bottom")
                if (v_bottom){
                    curvePoints.insert(addAdditionalEdgeNode()[0], at: bottomMost)
                    curvePoints.insert(addAdditionalEdgeNode()[1], at: topMost+2)
                    topMost = topMost+2
                }
                if (v_top){
                    curvePoints.insert(addAdditionalEdgeNode()[1], at: topMost)
                    curvePoints.insert(addAdditionalEdgeNode()[0], at: bottomMost+2)
                    bottomMost = bottomMost+2
                }
                
            }
        }

    }
    
    // lack of nodes on both edges
    func addAdditionalEdgeNode()->[SCNNode]{
        let right = SCNNode() // or bottom
        let temp = SCNNode()
        let left = SCNNode() // or top
        if (horizontally){
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
            right.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            right.geometry = SCNSphere(radius: 0.001)
            left.position = SCNVector3(xLowerBound,y,CGFloat(temp.position.z))
            left.name = "leftSide"
            left.geometry = SCNSphere(radius: 0.001)
            left.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        if (vertically){
            temp.position = SCNVector3(CGFloat(curvePoints[bottomMost].position.x),
                                       CGFloat(curvePoints[bottomMost].position.y) + height,CGFloat(curvePoints[bottomMost].position.z))
            let b = CGFloat(temp.position.x - curvePoints[topMost].position.x)
            let a = CGFloat(-(temp.position.y - curvePoints[topMost].position.y))
            let y = height+yLowerBound
            let x0 = CGFloat(temp.position.x)
            let y0 = CGFloat(temp.position.y)
            let x = (-b * (y-y0))/a + x0
            right.position = SCNVector3(x,y,CGFloat(temp.position.z))
            right.name = "topSide"
            right.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            right.geometry = SCNSphere(radius: 0.001)
            left.position = SCNVector3(x,yLowerBound,CGFloat(temp.position.z))
            left.name = "bottomSide"
            left.geometry = SCNSphere(radius: 0.001)
            left.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
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
        if (horizontally){
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
        }
        var j = height/(3*CGFloat(pieces))
        if (vertically){
            while (j < abs(a)){
                let y = y0 + j
                if (y <= yLowerBound+height && y >= yLowerBound){
                    let x = (-b * (y-y0))/a + x0
                    let node = SCNNode()
                    node.position = SCNVector3(x,y,CGFloat(nodeA.position.z))
                    arr.append(node)
                    
                }
                j = j+height/(3*CGFloat(pieces))
            }
        }
        return arr
        
    }

    
    func addExtraPoint(original_p: SCNNode)->SCNNode{
        let x = CGFloat(original_p.position.x)
        let y = original_p.position.y
        let point = SCNNode()
        point.geometry = SCNSphere(radius: 0.001)
        if (x == xLowerBound){
            point.position = SCNVector3(xLowerBound+width,CGFloat(y),0.001)
            original_p.name = "leftSide"
            point.name = "rightSide"
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        } else if (x == xLowerBound+width){
            point.position = SCNVector3(xLowerBound,CGFloat(y),0.001)
            original_p.name = "rightSide"
            point.name = "leftSide"
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        
        if (y == Float(yLowerBound) || CGFloat(y) == yLowerBound){
            point.position = SCNVector3(x,yLowerBound+height,0.001)
            original_p.name = "bottomSide"
            point.name = "topSide"
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        } else if (y == Float(yLowerBound+height) || CGFloat(y) == yLowerBound+height){
            point.position = SCNVector3(x,yLowerBound,0.001)
            original_p.name = "topSide"
            point.name = "bottomSide"
            point.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }

        edgePoints.updateValue(point, forKey: original_p)
        edgePoints.updateValue(original_p, forKey: point)
        return point
        
    }
    func addLine() {
        
        // add line to scene
        for j in 0...(curvePoints.count-1) {
            if (j != curvePoints.count-1){
                if ((curvePoints[j].name != "rightSide" && curvePoints[j+1].name != "leftSide"
                && curvePoints[j].name != "topSide" && curvePoints[j+1].name != "bottomSide" && (h_left || v_bottom))
                || (curvePoints[j+1].name != "rightSide" && curvePoints[j].name != "leftSide"
                && curvePoints[j+1].name != "topSide" && curvePoints[j].name != "bottomSide" && (h_right || v_top))){
                    let linenode = SCNNode.createLineNode(fromNode: curvePoints[j], toNode: curvePoints[j+1], color: UIColor.black)
                    line.addChildNode(linenode)
                }
            } else {
                if ((curvePoints[j].name != "rightSide" && curvePoints[0].name != "leftSide"
                    && curvePoints[j].name != "topSide" && curvePoints[0].name != "bottomSide" && (h_left || v_bottom))
                    || (curvePoints[0].name != "rightSide" && curvePoints[j].name != "leftSide"
                    && curvePoints[0].name != "topSide" && curvePoints[j].name != "bottomSide" && (h_right || v_top))){
                    let linenode = SCNNode.createLineNode(fromNode: curvePoints[j], toNode: curvePoints[0], color: UIColor.black)
                    line.addChildNode(linenode)
                   
                }
            }
            
        }
        
    }
    
    
    func addToScreen(){
        for i in 0...curvePoints.count-1{
            curvePointNode.addChildNode(curvePoints[i])
        }
        s.scene.rootNode.addChildNode(curvePointNode)
        s.scene.rootNode.addChildNode(line)

    }
    
    func removeFromScreen(){
        while (!s.scene.rootNode.childNodes.isEmpty){
            s.scene.rootNode.childNodes[0].removeFromParentNode()
        }
  
    }

    func updatePoints(){
        curvePoints.removeAll()
        curvePoints3D.removeAll()
        leftMost = 0
        rightMost = 0
        topMost = 0
        bottomMost = 0
        top = false
        bottom = false
        left = false
        right = false
        curvePoints = curve.points
        setUpCurvePoints()
        
    }

    
    func indexOfLine() -> Int{
        let arr = s.scene.rootNode.childNodes
        return arr.index(of: line)!
    }
    
    func indexOfPointsNode() -> Int{
        let arr = s.scene.rootNode.childNodes
        return arr.index(of: curvePointNode)!
    }
    
    func shorten(){
        if (odd){
            curve.manipulateOdd()
        } else {
            curve.manipulateEven()
        }
        s.scene.rootNode.childNodes[indexOfPointsNode()].removeFromParentNode()
        s.scene.rootNode.childNodes[indexOfLine()].removeFromParentNode()
        while (!line.childNodes.isEmpty){
            line.childNodes[0].removeFromParentNode()
        }
        while (!curvePointNode.childNodes.isEmpty){
            curvePointNode.childNodes[0].removeFromParentNode()
        }

        updatePoints()
        
        
        odd = !odd
    }
    


}
