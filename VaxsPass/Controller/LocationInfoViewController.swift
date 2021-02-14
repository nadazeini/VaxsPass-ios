//
//  LocationInfoViewController.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/13/21.
//

import UIKit

class LocationInfoViewController: UIViewController {
    @IBAction func dismissAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
