//
//  RoundButton.swift
//  Where's My Car?
//
//  Created by Chetwyn on 3/23/17.
//  Copyright © 2017 Clarke Enterprises. All rights reserved.
//

import UIKit
import MapKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.black.cgColor
    }

}
