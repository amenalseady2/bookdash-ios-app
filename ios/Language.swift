//
//  Language.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import UIKit
import Firebase

class Language: NSObject {
  var languageRef: FIRDatabaseReference
  var languageKey: String
  var enabled: Bool
  var languageAbbreviation: String
  var languageName: String
  
  init(key: String, dictionary: [String: Any]) {
    self.languageKey = key
    self.enabled = dictionary["enabled"] as! Bool
    self.languageAbbreviation = dictionary["languageAbbreviation"] as! String
    self.languageName = dictionary["languageName"] as! String
    self.languageRef = FIRDatabase.database().reference(withPath: "bd_languages").child(self.languageKey)
  }
}
