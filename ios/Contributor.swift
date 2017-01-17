//
//  Contributor.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation
import Firebase

class Contributor: NSObject {
  var contributorRef: FIRDatabaseReference
  var contributorKey: String
  var avatar: String
  var name: String
  var roles: [String: Any]

  init(key: String, dictionary: [String: Any]) {
    self.contributorKey = key
    if dictionary["avatar"] != nil {
      self.avatar = dictionary["avatar"] as! String
    } else {
      self.avatar = ""
    }
    self.name = dictionary["name"] as! String
    self.roles = dictionary["roles"] as! [String: Any]
    self.contributorRef = FIRDatabase.database().reference(withPath: "bd_contributors").child(self.contributorKey)
  }
}
