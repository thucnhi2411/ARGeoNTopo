//
//  PlaneScene.swift
//  ARGeometryAndTopology
//
//  Created by Thuc Nhi Le on 7/19/18.
//  Copyright © 2018 Thuc Nhi Le. All rights reserved.
//

import SpriteKit
import SceneKit
import UIKit

class PlaneScene: SKScene {
    var width3D = CGFloat()
    var height3D = CGFloat()
    var widthPlane = CGFloat()
    var heightPlane = CGFloat()
    var plane = SKShapeNode(rectOf: CGSize(width: 0, height: 0))
    var points: [SCNNode] = []
    var oldPoints: [SCNNode] = []
    var xLowerBound = CGFloat()
    var yLowerBound = CGFloat()
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        if (frame.width < frame.height){
            widthPlane = frame.width
            heightPlane = frame.width
        } else {
            widthPlane = frame.height
            heightPlane = frame.height
        }
        
        plane = SKShapeNode(rectOf: CGSize(width: widthPlane, height: heightPlane))
        displayScene()
    }
    
    func displayScene(){
        plane.position = CGPoint(x: frame.midX, y: frame.midY)
        plane.zPosition = 0
        plane.fillColor = UIColor.blue
        self.addChild(plane)
    }
    
    func addPoint(location: CGPoint){
        let point = SKShapeNode(rectOf: CGSize(width: widthPlane/20, height: heightPlane/20))
        point.position = location
        if (point.position.x > frame.midX-widthPlane/2 && point.position.x < frame.midX + widthPlane/2
            && point.position.y > frame.midY-heightPlane/2 && point.position.y < frame.midY + heightPlane/2) {
            point.zPosition = 0
            point.fillColor = UIColor.black
            self.addChild(point)
            let p = SCNNode()
            p.position = mapTo3D(loc: location)
            points.append(p)
            p.geometry = SCNSphere(radius: 0.001)
            p.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }

    }
    
    func mapTo3D(loc: CGPoint)-> SCNVector3{
        let x = ((loc.x-frame.midX)/widthPlane)*width3D
        let y = ((loc.y-frame.midY)/heightPlane)*height3D
        return SCNVector3(x,y,0.001)
    }
}

