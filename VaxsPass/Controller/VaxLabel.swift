//
//  VaxLabel.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//

import UIKit

class VaxLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = CGFloat(12)
    }

}
