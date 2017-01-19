//
//  BookDetail.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import Firebase

class BookDetail: NSObject {
  var bookKey: String
  var bookLanguage: String
  
  var bookCoverPageUrl: String
  var bookCoverPage: UIImage
  var bookTitle: String
  var bookUrl: String
  var createdDate: String
  var bookDescription: String
  var contributors: [[String: String]]
  
  init(book: Book, languages: [Language], contributors: [Contributor], roles: [Role]) {
    self.bookKey = book.bookKey
    var bookDetailLanguage: String!
    for language in languages {
      if book.bookLanguage == language.languageKey {
        bookDetailLanguage = language.languageName
      }
    }
    self.bookLanguage = bookDetailLanguage
    self.bookCoverPageUrl = book.bookCoverPageUrl
    let coverUrl = storageUrl.appending(book.bookCoverPageUrl)
    var bookCover: UIImage = UIImage()
    if coverUrl.hasPrefix("gs://") {
      FIRStorage.storage().reference(forURL: coverUrl).data(withMaxSize: INT64_MAX) { (data, error) in
        if let error = error {
          print("Error downloading: \(error)")
          return
        }
        bookCover = UIImage.init(data: data!)!
      }
    }
    self.bookCoverPage = bookCover as UIImage
    self.bookTitle = book.bookTitle as String
    self.bookUrl = book.bookUrl as String
    self.bookDescription = book.bookDescription as String
    
    let bookCreatedDate = book.createdDate as NSNumber
    let epochTime = TimeInterval(bookCreatedDate)/1000
    let unixTimestamp = Date(timeIntervalSince1970: epochTime)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let updatedTimeStamp = dateFormatter.string(from: unixTimestamp)
    self.createdDate = updatedTimeStamp
    
    var bookContributors = [[String: String]]()
    var contributorRole = [String: String]()
    for key in book.contributors.keys {
      for contributor in contributors {
        if key == contributor.contributorKey {
          contributorRole["contributorName"] = contributor.name as String
          for roleKey in contributor.roles.keys {
            for role in roles {
              if roleKey == role.roleKey {
                contributorRole["contributorRole"] = role.name as String
              }
            }
          }
        }
      }
      bookContributors.insert(contributorRole, at: 0)
    }
    self.contributors = bookContributors
  }
}
