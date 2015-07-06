//
//  FBAnnotationClusterView.swift
//  FBAnnotationClusteringSwift
//
//  Created by Robert Chen on 4/2/15.
//  Copyright (c) 2015 Robert Chen. All rights reserved.
//

import Foundation
import MapKit

struct ClusterViewConfiguration {

    let imageName   : String
    let fontSize    : CGFloat?
    let fontColor   : UIColor?
    let borderWidth : CGFloat?
    let borderColor : UIColor?

}

let clusterConfigurationDefault = ClusterViewConfiguration(imageName: "clusterSmall", fontSize: 12, fontColor: UIColor.whiteColor(),borderWidth: 3, borderColor: UIColor.whiteColor())

class FBAnnotationClusterView : MKAnnotationView {
    
    weak var countLabel : UILabel? = nil
    var configuration   : ClusterViewConfiguration = clusterConfigurationDefault

    convenience init(annotation: MKAnnotation?, reuseIdentifier: String?, configuration:ClusterViewConfiguration) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(configuration)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
    }

    func configure(configuration: ClusterViewConfiguration) {

        // change the size of the cluster image based on number of stories
        self.configuration = configuration

        setupLabel()

    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLabel(){

        if let _ = countLabel {
            countLabel!.removeFromSuperview()
            countLabel = nil
        }

        // label only if there's a font indicated in the config:
        if let fontSize = configuration.fontSize,
            fontColor = configuration.fontColor {

                let theLabel = UILabel(frame: bounds)
                theLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                theLabel.textAlignment = .Center
                theLabel.backgroundColor = UIColor.clearColor()
                theLabel.textColor = fontColor
                theLabel.adjustsFontSizeToFitWidth = true
                theLabel.minimumScaleFactor = 2
                theLabel.numberOfLines = 1
                theLabel.font = UIFont.boldSystemFontOfSize(fontSize)
                theLabel.baselineAdjustment = .AlignCenters

                if let theAnnotation = self.annotation as? FBAnnotationCluster {
                    theLabel.text = theAnnotation.annotations.count.description
                } else {
                    theLabel.text = ""
                }

                addSubview(theLabel)

                countLabel = theLabel

        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        
        // Images are faster than using drawRect:
        if let imageAsset = UIImage(named: configuration.imageName) {
            countLabel?.frame = self.bounds
            image = imageAsset
            centerOffset = CGPointZero

            // adds a border around the  circle if asked for
            if let borderColor = configuration.borderColor,
                borderWidth = configuration.borderWidth {
                    layer.borderColor = borderColor.CGColor
                    layer.borderWidth = borderWidth
                    layer.cornerRadius = self.bounds.size.width / 2
            }
        }
        

    }
    
}