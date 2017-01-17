//
//  Role.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation
import Firebase

class Role: NSObject {
  var roleRef: FIRDatabaseReference
  var roleKey: String
  var name: String

  init(key: String, dictionary: [String: Any]) {
    self.roleKey = key
    self.name = dictionary["name"] as! String
    self.roleRef = FIRDatabase.database().reference(withPath: "bd_roles").child(self.roleKey)
  }
}
