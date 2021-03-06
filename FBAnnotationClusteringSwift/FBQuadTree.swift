//
//  FBQuadTree.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBQuadTree {
    
    var rootNode:FBQuadTreeNode? = nil
    
    let nodeCapacity = 8
    
    init (){
        
        rootNode = FBQuadTreeNode(boundingBox:MKMapRectWorld.boundingBox)
        
    }
    
    func insertAnnotation(annotation:MKAnnotation) -> Bool {
        return insertAnnotation(annotation, toNode:rootNode!)
    }
    
    func insertAnnotation(annotation:MKAnnotation, toNode node:FBQuadTreeNode) -> Bool {
        
        if !node.boundingBox!.containsCoordinate(annotation.coordinate) {
            return false
        }
        
        if node.count < nodeCapacity {
            node.annotations.append(annotation)
            node.count++
            return true
        }
        
        if node.isLeaf {
            node.subdivide()
        }
        
        if insertAnnotation(annotation, toNode:node.northEast!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.northWest!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.southEast!) {
            return true
        }
        
        if insertAnnotation(annotation, toNode:node.southWest!) {
            return true
        }
        
        
        return false
        
    }
    
    func enumerateAnnotationsInBox(box:FBBoundingBox, callback: MKAnnotation -> Void){
        enumerateAnnotationsInBox(box, withNode:rootNode!, callback: callback)
    }
    
    func enumerateAnnotationsUsingBlock(callback: MKAnnotation -> Void){
        enumerateAnnotationsInBox(MKMapRectWorld.boundingBox, withNode:rootNode!, callback:callback)
    }
    
    func enumerateAnnotationsInBox(box:FBBoundingBox, withNode node:FBQuadTreeNode, callback: MKAnnotation -> Void){
        if (!node.boundingBox!.intersects(box)) {
            return;
        }
        
        let tempArray = node.annotations
        
        for annotation in tempArray {
            if ( box.containsCoordinate(annotation.coordinate)) {
                callback(annotation);
            }
        }
        
        if node.isLeaf {
            return
        }
        
        enumerateAnnotationsInBox(box, withNode: node.northEast!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.northWest!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.southEast!, callback: callback)
        enumerateAnnotationsInBox(box, withNode: node.southWest!, callback: callback)
        
    }
    
}