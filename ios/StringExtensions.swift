//
//  StringExtensions.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation

extension String {
  func fileName() -> String {
    if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
      return fileNameWithoutExtension
    } else {
      return ""
    }
  }
  
  func fileExtension() -> String {
    if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
      return fileExtension
    } else {
      return ""
    }
  }
}
