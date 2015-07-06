//
//  ViewController.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import UIKit
import MapKit

class FBViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let numberOfLocations = 1000
    
    let clusteringManager = FBClusteringManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let array:[MKAnnotation] = randomLocationsWithCount(numberOfLocations)
        
        clusteringManager.addAnnotations(array)

        mapView.centerCoordinate = CLLocationCoordinate2DMake(0, 0);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Utility
    
    func randomLocationsWithCount(count:Int) -> [FBAnnotation] {
        var array:[FBAnnotation] = []
        for _ in 0...count {
            let a:FBAnnotation = FBAnnotation()
            a.coordinate = CLLocationCoordinate2D(latitude: drand48() * 40 - 20, longitude: drand48() * 80 - 40 )
            array.append(a)
        }
        return array
    }

}

let clusterConfigurationSmall = clusterConfigurationDefault
let clusterConfigurationMedium = ClusterViewConfiguration(imageName: "clusterMedium", fontSize: 13, fontColor: UIColor.whiteColor(), borderWidth: 4, borderColor: UIColor.whiteColor())
let clusterConfigurationLarge = ClusterViewConfiguration(imageName: "clusterLarge", fontSize: 14, fontColor: UIColor.whiteColor(), borderWidth: 5, borderColor: UIColor.whiteColor())

extension FBViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        
        NSOperationQueue().addOperationWithBlock({
        
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            
            let mapRectWidth:Double = self.mapView.visibleMapRect.size.width
            
            let scale:Double = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.mapView.displayClusterAnnotations(annotationArray)

        })

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        
        if let theClusterAnnotation = annotation as? FBAnnotationCluster {
            
            reuseId = "Cluster"
            var clusterView : FBAnnotationClusterView? = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? FBAnnotationClusterView
            if nil == clusterView {
                clusterView = FBAnnotationClusterView(annotation: theClusterAnnotation, reuseIdentifier: reuseId)
            } else {
                clusterView?.annotation = annotation
            }

            let numObjects = theClusterAnnotation.annotations.count
            if numObjects <= 5 {
                clusterView?.configure(clusterConfigurationSmall)
            } else if numObjects > 5 && numObjects <= 10 {
                clusterView?.configure(clusterConfigurationMedium)
            } else {
                clusterView?.configure(clusterConfigurationLarge)
            }
            return clusterView
            
        } else {
        
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            
            pinView!.pinTintColor = UIColor.greenColor()
            
            return pinView
        }
        
    }
    
}
