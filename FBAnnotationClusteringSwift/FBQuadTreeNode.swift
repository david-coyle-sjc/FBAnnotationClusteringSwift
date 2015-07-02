//
//  FBQuadTreeNode.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBQuadTreeNode {
    
    var boundingBox:FBBoundingBox?
    
    var northEast:FBQuadTreeNode?
    var northWest:FBQuadTreeNode?
    var southEast:FBQuadTreeNode?
    var southWest:FBQuadTreeNode?
    
    var count = 0
    
    var annotations:[MKAnnotation] = []
    
    // MARK: - Initializers
    
    init(){

    }
    
    convenience init(boundingBox box:FBBoundingBox){
        self.init()
        boundingBox = box
    }
    
    // MARK: - Instance functions
    
    func isLeaf() -> Bool {
        return (northEast == nil) ? true : false
    }
    
    func subdivide(){
        
        northEast = FBQuadTreeNode()
        northWest = FBQuadTreeNode()
        southEast = FBQuadTreeNode()
        southWest = FBQuadTreeNode()
        
        let box = boundingBox!
        
        let xMid:CGFloat = (box.xf + box.x0) / 2.0
        let yMid:CGFloat = (box.yf + box.y0) / 2.0
        
        
        northEast!.boundingBox = FBBoundingBox(x0: xMid,   y0:box.y0, xf:box.xf, yf:yMid)
        northWest!.boundingBox = FBBoundingBox(x0: box.x0, y0:box.y0, xf:xMid,   yf:yMid)
        southEast!.boundingBox = FBBoundingBox(x0: xMid,   y0:yMid,   xf:box.xf, yf:box.yf)
        southWest!.boundingBox = FBBoundingBox(x0: box.x0, y0:yMid,   xf:xMid,   yf:box.yf)
    }
    
}