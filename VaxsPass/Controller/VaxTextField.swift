//
//  VaxTextField.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 14/02/21.
//

import UIKit

class VaxTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = CGFloat(8)
        self.layer.borderWidth = CGFloat(2)
        self.layer.borderColor = CGColor.init(gray: 2.0, alpha: 0.0)
        self.textAlignment = .natural
    }
}
