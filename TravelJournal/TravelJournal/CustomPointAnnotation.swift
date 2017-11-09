//
//  CustomPointAnnotation.swift
//  Assignment2
//
//  Created by Araceli Teixeira on 01/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var pointColor: UIColor
    
    init(_ pointColor: UIColor) {
        self.pointColor = pointColor
        super.init()
    }
}
