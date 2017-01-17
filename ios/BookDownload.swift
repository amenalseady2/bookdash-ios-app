//
//  BookDownload.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation

class BookDownload {
  var dictionary: [String: AnyObject]?
  
  init(dictionary: [String: AnyObject]) {
    self.dictionary = dictionary
  }
  
  func coverImage() -> UIImage? {
    if let cover = dictionary?["cover"] as? UIImage {
      return cover
    }
    return nil
  }

  func pageImage(index: Int) -> UIImage? {
    if let pages = dictionary?["pages"] as? [UIImage] {
      if let page = pages[index] as? UIImage {
        return page
      }
    }
    return nil
  }
  
  func numberOfPages() -> Int {
    if let pages = dictionary?["pages"] as? [UIImage] {
      return pages.count
    }
    return 0
  }
}
