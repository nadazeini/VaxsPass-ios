//
//  FirebaseReferences.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/14/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct FirebaseReferences {
    static let usersRef = Database.database().reference().ref.child("userInfo")
}
