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
    var curvePoints: [SCNNode] = []
    var line: [SCNNode] = []
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
        pointCnt = pieces*3
        plane = PlaneDisplay(scene: s, pieceCount: pieces, w: width, h: height, l: length)
    }
    
    func add(){
        plane.add()
        create()
        addCurvePoint()
        addLine()
        curve.points = curvePoints
        curve.line = line
    }
    
    func create(){
        let temp = SCNNode()
        shapePoints = Array(repeating: Array(repeating: temp, count: pieces), count: pieces)
        var i = 1
        for m in 1...pieces {
            var j = 1
            for n in 1...pieces {
                let node = SCNNode()
                let u = CGFloat(i)*p/CGFloat(pieces) // torus angle
                let v = CGFloat(j)*p/CGFloat(pieces) // tube angle
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
        let y = -rTube*sin(tubeA+p)
        let z = (rTorus+rTube*cos(tubeA+p))*sin(torusA)
        return SCNVector3(x,y,z)
    }
    
    // angle[0] = torus angle
    // angle[1] = tube angle
    func positionToAngle(x: CGFloat, y:CGFloat) -> [CGFloat] {
        var angle: [CGFloat] = []
        let torusA = 2*p*(x+width/2)/rTorus
        angle.append(torusA)
        let tubeA = 2*p*(y-height/2)/rTube
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
                let x = CGFloat(xP)*rTorus/CGFloat(pointCnt)
                //let y = 0
                let y = CGFloat(yP)*0.005/3+0.005
                p1.position = (mapToTorus(torusA: positionToAngle(x: x, y: CGFloat(y) )[0], tubeA: positionToAngle(x: x, y: CGFloat(y))[1]))
                curvePoints.append(p1)
                s.scene.rootNode.addChildNode(p1)
            }
        }
        
        
    }
    
    // connect shapePoints to create curve
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

    func shorten(){
        if (odd){
            curve.manipulateOdd()
        } else {
            curve.manipulateEven()
        }
        odd = !odd
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
