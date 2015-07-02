//
//  MKMapView+FBClusterExtensions.swift
//  FBAnnotationClusteringSwift
//
//  Created on 2015.7.2.
//  No Copyright, No rights reserved.
//

import MapKit


extension MKMapView {

    func displayClusterAnnotations(annotations: [MKAnnotation]){

        dispatch_async(dispatch_get_main_queue())  {

            let before : NSMutableSet = NSMutableSet(array: self.annotations)
            before.removeObject(self.userLocation)
            let after = NSSet(array: annotations)
            let toKeep = NSMutableSet(set: before)
            toKeep.intersectSet(after as Set<NSObject>)
            let toAdd = NSMutableSet(set: after)
            toAdd.minusSet(toKeep as Set<NSObject>)
            let toRemove = NSMutableSet(set: before)
            toRemove.minusSet(after as Set<NSObject>)

            self.addAnnotations(toAdd.allObjects as! [MKAnnotation])
            self.removeAnnotations(toRemove.allObjects as! [MKAnnotation])
        }

    }

}