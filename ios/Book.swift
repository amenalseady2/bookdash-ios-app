//
//  Book.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import UIKit
import Firebase

class Book: NSObject {
  var bookRef: FIRDatabaseReference
  var bookKey: String
  var bookCoverPageUrl: String
  var bookEnabled: Bool
  var bookDescription: String
  var bookLanguage: String
  var bookTitle: String
  var bookUrl: String
  var contributors: [String: Any]
  var createdDate: NSNumber
  
  init(key: String, dictionary: [String: Any]) {
    self.bookKey = key
    self.bookCoverPageUrl = dictionary["bookCoverPageUrl"] as! String
    self.bookEnabled = dictionary["bookEnabled"] as! Bool
    if dictionary["bookDescription"] != nil {
      self.bookDescription = dictionary["bookDescription"] as! String
    } else {
      self.bookDescription = ""
    }
    self.bookLanguage = dictionary["bookLanguage"] as! String
    self.bookTitle = dictionary["bookTitle"] as! String
    self.bookUrl = dictionary["bookUrl"] as! String
    self.contributors = dictionary["contributors"] as! [String: Any]
    self.createdDate = dictionary["createdDate"] as! NSNumber
    self.bookRef = FIRDatabase.database().reference(withPath: "bd_books").child(self.bookKey)
  }
}
