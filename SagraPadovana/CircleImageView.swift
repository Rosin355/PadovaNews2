//
//  CircleImageView.swift
//  PadovaNews
//
//  Created by Romesh Singhabahu on 12/04/15.
//  Copyright (c) 2015 Romesh Singhabahu. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        clipsToBounds = true
        layer.cornerRadius = self.bounds.size.width / 2.0
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 2.0
    }

}
