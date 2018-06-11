//
//  Torus.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 5/23/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


//    A_ _ _ _ _ _ _ _ _ _ _ _D
//    |_|_|_|_|_|_|_|_|_|_|_|_|  first
//    |_|_|_|_|_|_|_|_|_|_|_|_|  second
//    |_|_|_|_|_|_|_|_|_|_|_|_|  third
//    |_|_|_|_|_|_|_|_|_|_|_|_|  fourth
//    B                       C
// How to make a torus: glue A->B, D->C to make a tube then glue AB->DC to make a torus
class Torus: NSObject {
    var r = CGFloat() // AB is perimeter
    var pieces: Int
    var height = CGFloat()
    var p = CGFloat.pi //3.14
    var width = CGFloat() //width
    var length = CGFloat()
    var s: ARSCNView
    var first: [SCNNode] = []
    var second: [SCNNode] = []
    var third: [SCNNode] = []
    var fourth: [SCNNode] = []
    var tubes: [SCNNode] = []
    //
    init(scene: ARSCNView,  pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        r = h/(2*p) //AB: h
        pieces = pieceCount
        width = w //AD
        length = l
        height = h //AB
        s = scene
    }
    
    func add(){
        firstQuadrant()
        secondQuadrant()
        thirdQuadrant()
        fourthQuadrant()
        addUp()
    }

    func addUp(){
        for i in 0...pieces-1 {
            let node = SCNNode()
            //let j = 0
            for j in 0...pieces/4-1 {
                node.addChildNode(first[i+j*pieces])
                node.addChildNode(second[i+j*pieces])
                node.addChildNode(third[i+j*pieces])
                node.addChildNode(fourth[i+j*pieces])
            }
            tubes.append(node)
            
        }
        let tube = Tube(scene: s, pieceCount: tubes.count, perimeter: width, planeArr: tubes)
        tube.add()
    }
    
    
    func fourthQuadrant(){
        var i = CGFloat(1)
        for _ in 1...pieces/4 {
            for _ in 0...pieces-1 {
                let node = SCNNode()
                let y = CGFloat(sin(i*p/CGFloat(pieces)))
                let x = CGFloat(0)
                let z = CGFloat(cos(i*p/CGFloat(pieces)))
                node.geometry = SCNBox(width: width/CGFloat(pieces), height: height/CGFloat(pieces/4), length: length, chamferRadius: 0)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.position = SCNVector3(x,r*y,r*z )
                node.eulerAngles = SCNVector3(-i*p/CGFloat(pieces),0,0)
                fourth.append(node)
            }
            i = i+2
        }
    }

    func thirdQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            for _ in 0...pieces-1 {
                let node = SCNNode()
                let y = CGFloat(sin(i*p/CGFloat(pieces)))
                let x = CGFloat(0)
                let z = CGFloat(cos(i*p/CGFloat(pieces)))
                node.geometry = SCNBox(width: width/CGFloat(pieces), height: height/CGFloat(pieces/4), length: length, chamferRadius: 0)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                node.position = SCNVector3(x,-r*y,r*z)
                node.eulerAngles = SCNVector3(i*p/CGFloat(pieces),0,0)
                third.append(node)
            }
            i = i-2
        }
    }
    
    func firstQuadrant(){
        var i = CGFloat(pieces/2)
        i = i-1
        for _ in 1...pieces/4 {
            for _ in 0...pieces-1 {
                let node = SCNNode()
                let y = CGFloat(sin(i*p/CGFloat(pieces)))
                let x = CGFloat(0)
                let z = CGFloat(cos(i*p/CGFloat(pieces)))
                node.geometry = SCNBox(width: width/CGFloat(pieces), height: height/CGFloat(pieces/4), length: length, chamferRadius: 0)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                node.position = SCNVector3(x,r*y,-r*z)
                node.eulerAngles = SCNVector3(i*p/CGFloat(pieces),0,0)
                first.append(node)
            }
            i = i-2
        }
    }
    

    
    func secondQuadrant(){
        var i = CGFloat(1)
        for _ in 1...pieces/4 {
            for _ in 0...pieces-1 {
                let node = SCNNode()
                let y = CGFloat(sin(i*p/CGFloat(pieces)))
                let x = CGFloat(0)
                let z = CGFloat(cos(i*p/CGFloat(pieces)))
                node.geometry = SCNBox(width: width/CGFloat(pieces), height: height/CGFloat(pieces/4), length: length, chamferRadius: 0)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                node.position = SCNVector3(x,-r*y,-r*z)
                node.eulerAngles = SCNVector3(-i*p/CGFloat(pieces),0,0)
                second.append(node)
            }
            i = i+2
        }
    }
    

    
}



