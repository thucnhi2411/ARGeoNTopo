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
    var planes: [[SCNNode]] = []
    var length = CGFloat(0.002)
    var p = CGFloat.pi
    var first: [SCNNode] = []
    var second: [SCNNode] = []
    var third: [SCNNode] = []
    var fourth: [SCNNode] = []
    var tubes: [SCNNode] = []
    
    init(scene: ARSCNView, pieceCount: Int, w: CGFloat, h: CGFloat, l: CGFloat){
        width = w
        pieces = pieceCount
        length = l
        height = h
        s = scene
    }
    
    func add(){
        addPlane()
        addUp()
    }
    
    func addUp(){
        planes.append(first)
        planes.append(second)
        planes.append(third)
        planes.append(fourth)
        for i in 0...planes.count-1 {
            let arr = planes[i]
            for j in 0...arr.count-1 {
                s.scene.rootNode.addChildNode(arr[j])
            }
        }
    }
    
    
    func addPlane(){
        let wPiece = width/CGFloat(pieces)
        let hPiece = height/CGFloat(pieces)
        for i in 1...pieces { // row
            for j in 0...pieces-1 { //col
                let node = SCNNode()
                node.geometry = SCNBox(width: wPiece, height: hPiece, length: length, chamferRadius: 0)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                node.position = SCNVector3(CGFloat(j)*wPiece+wPiece,CGFloat(i-1)*hPiece+hPiece,CGFloat(0) )
                if (i<=pieces/4){
                    first.append(node)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                } else if (i>pieces/4 && i<=pieces/2){
                    second.append(node)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                } else if (i>pieces/2 && i<=3*pieces/4){
                    third.append(node)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                } else {
                    fourth.append(node)
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                }
                
            }
        }
    }



    
}
