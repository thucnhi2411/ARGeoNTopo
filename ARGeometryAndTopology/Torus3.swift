//
//  Torus3.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/28/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GLKit

class Torus3: NSObject {
    
    //    A_ _ _ _ _ _ _ _ _ _ _ _D
    //    |_|_|_|_|_|_|_|_|_|_|_|_|  first
    //    |_|_|_|_|_|_|_|_|_|_|_|_|  second
    //    |_|_|_|_|_|_|_|_|_|_|_|_|  third
    //    |_|_|_|_|_|_|_|_|_|_|_|_|  fourth
    //    B                       C
    // How to make a torus: glue A->B, D->C to make a tube then glue AB->DC to make a torus
    
    var rTube = CGFloat() // AB is perimeter
    var rTorus = CGFloat() // AD is perimeter
    var pieces: Int
    var height = CGFloat()
    var p = CGFloat.pi //3.14
    var width = CGFloat() //width
    var length = CGFloat()
    var s: ARSCNView
    var shapePoints: [[SCNNode]] = []
    var curvePoints3D: [SCNNode] = []
    var line = SCNNode()
    var curvePointNode = SCNNode()
    var curve: Curve
    var odd = true
    var pointCnt: Int
    var plane: PlaneDisplay

    //
    init(scene: ARSCNView,  pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        rTube = h/(2*p) //AB: h
        rTorus = w/(2*p)
        pieces = pieceCount
        width = w //AD
        length = l
        height = h //AB
        s = scene
        curve = Curve(scene: s, radius: rTorus+rTube)
        pointCnt = pieces
        plane = PlaneDisplay(scene: s, pieceCount: pieces, w: width, h: height, l: length)
    }
    
    func add(){
        plane.add()
        create()
        addCurvePoints()
        addLine()
    }
    
    func create(){
        let temp = SCNNode()
        shapePoints = Array(repeating: Array(repeating: temp, count: pieces), count: pieces)
        var i = 1
        for m in 1...pieces {
            var j = 1
            for n in 1...pieces {
                //let node = SCNNode()
                let node = plane.planePoints[m-1][n-1]
                let u = positionToAngle(x: CGFloat(node.position.x), y: CGFloat(node.position.y))[0]
                let v = positionToAngle(x: CGFloat(node.position.x), y: CGFloat(node.position.y))[1]
                node.geometry = SCNSphere(radius: 0.001)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.position = mapToTorus(torusA: u, tubeA: v)
                node.opacity = 0.5
                shapePoints[m-1][n-1] = node
                j = j+2
                
            }
            i = i+2
            
            
        }
        addTriangle()

        
    }
    

    
    func mapToTorus(torusA: CGFloat, tubeA: CGFloat) -> SCNVector3{
        let x = (rTorus+rTube*cos(tubeA+p))*cos(torusA)
        let y = rTube*sin(tubeA+p)
        let z = (rTorus+rTube*cos(tubeA+p))*sin(torusA)
        return SCNVector3(x,y,z)
    }
    
    // angle[0] = torus angle
    // angle[1] = tube angle
    func positionToAngle(x: CGFloat, y:CGFloat) -> [CGFloat] {
        var angle: [CGFloat] = []
        let torusA = (x+width/2)*2*p/width
        angle.append(torusA)
        let tubeA = (y-height/2)*2*p/height
        angle.append(tubeA)
        return angle
    }
    
    func addTriangle(){
        // add line to scene
        for i in 0...(shapePoints[0].count-1) {
            for j in 0...(shapePoints[0].count-1) {
                var triangle1  = SCNNode()
                var triangle2  = SCNNode()
                if (j != shapePoints[0].count-1 && i != shapePoints[0].count-1){
                    triangle1 = SCNNode.createTriangleNode(first: shapePoints[i][j], second: shapePoints[i][j+1],
                                                           third: shapePoints[i+1][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: shapePoints[i+1][j+1], second: shapePoints[i][j+1],
                                                           third: shapePoints[i+1][j],
                                                           color: UIColor.white)
                } else if (j == shapePoints[0].count-1 && i != shapePoints[0].count-1) {
                    triangle1 = SCNNode.createTriangleNode(first: shapePoints[i][j], second: shapePoints[i][0],
                                                           third: shapePoints[i+1][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: shapePoints[i+1][0], second: shapePoints[i][0],
                                                           third: shapePoints[i+1][j],
                                                           color: UIColor.white)
                } else if (j != shapePoints[0].count-1 && i == shapePoints[0].count-1) {
                    triangle1 = SCNNode.createTriangleNode(first: shapePoints[i][j], second: shapePoints[i][j+1],
                                                           third: shapePoints[0][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: shapePoints[0][j+1], second: shapePoints[i][j+1],
                                                           third: shapePoints[0][j],
                                                           color: UIColor.white)
                } else {
                    triangle1 = SCNNode.createTriangleNode(first: shapePoints[i][j], second: shapePoints[i][0],
                                                           third: shapePoints[0][j],
                                                           color: UIColor.white)
                    triangle2 = SCNNode.createTriangleNode(first: shapePoints[0][0], second: shapePoints[i][0],
                                                           third: shapePoints[0][j],
                                                           color: UIColor.white)
                }
                s.scene.rootNode.addChildNode(triangle1)
                s.scene.rootNode.addChildNode(triangle2)
            }
        }
        
    }
    
    
    // connect points to create curve
    func addCurvePoints(){
        var arr = plane.curvePoints3D
        curvePointNode.name = "points"
        for i in 0...arr.count-1 {
            let p1 = SCNNode()
            let node = arr[i]
            if (node.name != "rightSide"){
                let x = CGFloat(node.position.x)
                let y = CGFloat(node.position.y)
                p1.position = (mapToTorus(torusA: positionToAngle(x: x, y: y )[0], tubeA: positionToAngle(x: x, y: y)[1]))
                curvePoints3D.append(p1)
                p1.geometry = SCNSphere(radius: 0.0005)
                p1.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            }
        }
        addToScreen()
    }
    

    func addLine(){
        line.name = "line"
        // add line to scene
        for j in 0...(curvePoints3D.count-1) {
            if (j != curvePoints3D.count-1){
                let linenode = SCNNode.createLineNode(fromNode: curvePoints3D[j], toNode: curvePoints3D[j+1], color: UIColor.black)
                line.addChildNode(linenode)
                
                
            } else {
                let linenode = SCNNode.createLineNode(fromNode: curvePoints3D[j], toNode: curvePoints3D[0], color: UIColor.black)
                line.addChildNode(linenode)
            }
            
        }
        s.scene.rootNode.addChildNode(line)
    }
    
    func addToScreen(){
        for i in 0...curvePoints3D.count-1{
            curvePointNode.addChildNode(curvePoints3D[i])
        }
        s.scene.rootNode.addChildNode(curvePointNode)
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
        plane.shorten()
        s.scene.rootNode.childNodes[indexOfPointsNode()].removeFromParentNode()
        s.scene.rootNode.childNodes[indexOfLine()].removeFromParentNode()
        while (!line.childNodes.isEmpty){
            line.childNodes[0].removeFromParentNode()
        }
        while (!curvePointNode.childNodes.isEmpty){
            curvePointNode.childNodes[0].removeFromParentNode()
        }
        curvePoints3D.removeAll()
        addCurvePoints()
        addLine()
    }

}

extension SCNNode {
    static func createTriangleNode(first: SCNNode, second: SCNNode, third: SCNNode, color: UIColor) -> SCNNode {
        let triangle1 = createTriangle(vector: first.position, vector: second.position, vector: third.position)
        let node = SCNNode(geometry: triangle1)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = color
        triangle1.materials = [planeMaterial]
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.opacity = 0.5
        return node
    }
    

    
    static func createTriangle(vector vector1: SCNVector3, vector vector2: SCNVector3, vector vector3: SCNVector3)-> SCNGeometry {
        let indices: [Int32] = [0, 1, 2]
        let source = SCNGeometrySource(vertices: [vector1, vector2, vector3])
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        return SCNGeometry(sources: [source], elements: [element])
    }
}
