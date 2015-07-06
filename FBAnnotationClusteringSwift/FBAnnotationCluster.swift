//
//  FBAnnotationCluster.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

class FBAnnotationCluster : NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var title:String? = ""
    var subtitle:String? = nil
    
    var annotations:[MKAnnotation] = []
    
}
