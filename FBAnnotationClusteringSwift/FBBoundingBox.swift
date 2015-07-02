//
//  FBBoundingBox.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

struct FBBoundingBox {
    let x0, y0, xf, yf: CGFloat

    func containsCoordinate(coordinate:CLLocationCoordinate2D) -> Bool {
        let containsX:Bool = (self.x0 <= CGFloat(coordinate.latitude)) && (CGFloat(coordinate.latitude) <= self.xf)
        let containsY:Bool = (self.y0 <= CGFloat(coordinate.longitude)) && (CGFloat(coordinate.longitude) <= self.yf)
        return (containsX && containsY)
    }

    func intersects(box2:FBBoundingBox) -> Bool {
        return (self.x0 <= box2.xf && self.xf >= box2.x0 && self.y0 <= box2.yf && self.yf >= box2.y0);
    }

    var mapRect : MKMapRect { get {
        let topLeft:MKMapPoint  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(CLLocationDegrees(self.x0), CLLocationDegrees(self.y0)));
        let botRight:MKMapPoint  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(CLLocationDegrees(self.xf), CLLocationDegrees(self.yf)));

        return MKMapRectMake(topLeft.x, botRight.y, fabs(botRight.x - topLeft.x), fabs(botRight.y - topLeft.y));
        }
    }


}

extension MKMapRect {

    var boundingBox : FBBoundingBox { get {
        let topLeft: CLLocationCoordinate2D = MKCoordinateForMapPoint(self.origin)
        let botRight: CLLocationCoordinate2D = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(self), MKMapRectGetMaxY(self)))

        let minLat: CLLocationDegrees = botRight.latitude
        let maxLat: CLLocationDegrees = topLeft.latitude

        let minLon: CLLocationDegrees = topLeft.longitude
        let maxLon: CLLocationDegrees = botRight.longitude

        return FBBoundingBox(x0: CGFloat(minLat), y0: CGFloat(minLon), xf: CGFloat(maxLat), yf: CGFloat(maxLon))
        }
    }
    
}