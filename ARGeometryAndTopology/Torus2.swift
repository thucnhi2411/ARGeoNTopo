//
//  Torus2.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 6/12/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GLKit

class Torus2: NSObject {

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
    var planes: [[SCNNode]] = []
    //
    init(scene: ARSCNView,  pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        rTube = h/(2*p) //AB: h
        rTorus = w/(2*p)
        pieces = pieceCount
        width = w //AD
        length = l
        height = h //AB
        s = scene
    }
    
    func add(){
        create()
    }
    
    
    func create(){
        var i = 1
        for _ in 1...pieces {
            var tubes: [SCNNode] = []
            var j = 1
            for _ in 1...pieces {
                let node = SCNNode()
                let u = CGFloat(i)*p/CGFloat(pieces)
                let v = CGFloat(j)*p/CGFloat(pieces)
                let x = (rTorus+rTube*cos(v))*cos(u)
                let y = rTube*sin(v)
                let z = (rTorus+rTube*cos(v))*sin(u)
                node.geometry = SCNBox(width: width/CGFloat(pieces), height: height/CGFloat(pieces), length: length, chamferRadius: 0)
//                let layer = CALayer()
//                layer.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
//                layer.borderColor = UIColor.black.cgColor
//                layer.borderWidth = 10
//
//                // Create a material from the layer and assign it
//                let material = SCNMaterial()
//                material.diffuse.contents = layer
//                material.isDoubleSided = true
//                node.geometry?.materials = [material]
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.position = SCNVector3(x,y,z)
                //node.eulerAngles = SCNVector3(CGFloat(j*2)*p/CGFloat(pieces),0,0)
                let matrix = MatrixFromParametric(u: u, v: v, a: rTorus, b: rTube)
                node.eulerAngles = EulerFromMatrix(transMatrix: matrix)
                tubes.append(node)
                s.scene.rootNode.addChildNode(node)
                j = j+2
                
            }
            i = i+2
            
            
        }
        
    }
    
        
    
    func MatrixFromParametric(u: CGFloat, v:CGFloat, a: CGFloat, b:CGFloat) -> [[Float]]{
        var transMatrix : [[Float]] = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        // V
        let xV = Float(-b*cos(u)*sin(v))
        let yV = Float(b*cos(v))
        let zV = Float(-b*sin(u)*sin(v))
        var fV = [Float]()
        fV.append(xV)
        fV.append(yV)
        fV.append(zV)
        // U
        let xU = Float(sin(u)*(-(a+b*cos(v))))
        let yU = Float(0)
        let zU = Float(cos(u)*(a+b*cos(v)))
        var fU = [Float]()
        fU.append(xU)
        fU.append(yU)
        fU.append(zU)
        // get unit vector
        var vectorU = GLKVector3Make(xU, yU, zU)
        vectorU = GLKVector3Normalize(vectorU)
        var vectorV = GLKVector3Make(xV, yV, zV)
        vectorV = GLKVector3Normalize(vectorV)
        // normal vector
        let normalVector = GLKVector3CrossProduct(vectorU, vectorV)
        var normalV: [Float] = []
        normalV.append(normalVector.x)
        normalV.append(normalVector.y)
        normalV.append(normalVector.z)
        for i in 0...2 {
            transMatrix[i][0] = fU[i];
            transMatrix[i][1] = fV[i];
            transMatrix[i][2] = normalVector[i];
        }
        return transMatrix
    }
    

    
    // Compute the Euler angles corresponding to a transformation matrix.
    // The Euler angles given use the convention: eulerAngles[0] rotation
    // around x-axis, then eulerAngles[1] rotation around y-axis, finally
    // eulerAngles[2] rotation around z-axis.
    // The algorithm used is Mike Day's alteration of Ken Shoemake's,
    // in order to achieve better numerical stability.
    func EulerFromMatrix(transMatrix: [[Float]]) -> SCNVector3 {
        var eulerAngles: [Float] = Array(repeating: 0, count: 3)
        eulerAngles[0] = atan2(transMatrix[2][1], transMatrix[2][2])
        let c2 = sqrt(pow(transMatrix[0][0],2) + pow(transMatrix[1][0],2))
        eulerAngles[1] = atan2(-transMatrix[2][0], c2)
        let s1 = sin(eulerAngles[0])
        let c1 = cos(eulerAngles[0])
        eulerAngles[2] = atan2(s1*transMatrix[0][2] - c1*transMatrix[0][1],
        c1*transMatrix[1][1] - s1*transMatrix[1][2])
        let val = SCNVector3(eulerAngles[0],eulerAngles[1],eulerAngles[2])
        print(val)
        return val;
        
    }
    
}





