//
//  BooksViewController.swift
//  BookDash
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class BooksViewController: UICollectionViewController {
  @IBOutlet var menuButton: UIBarButtonItem!
  @IBOutlet var languagesButton: UIBarButtonItem!
  let reuseIdentifier = "BookCell"
  let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
  let itemsPerRow: CGFloat = 3
  
  let defaultBookLanguage = "AllBookLanguages"
  var bookLanguage: String!
  var selectedLanguageName: String!
  var selectedLanguageKey: String!
  
  var books = [Book]()
  var roles = [Role]()
  var contributors = [Contributor]()
  var languages = [Language]()
  var bookDetail = [String: Any]()
  
  func assignBackground() {
    let background = UIImage(named: "Background")
    let imageView: UIImageView = UIImageView(frame: view.bounds)
    imageView.contentMode =  UIViewContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = background
    imageView.center = view.center
    collectionView?.backgroundView = imageView
  }

  func setMenus() {
    if revealViewController() != nil {
      revealViewController().rearViewRevealWidth = 170
      menuButton.target = revealViewController()
      menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
      
      revealViewController().rightViewRevealWidth = 180
      languagesButton.target = revealViewController()
      languagesButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
    }
  }
  
  func setBookLanguageSelection() {
    let defaults = UserDefaults.standard
    if let defaultLanguage = defaults.string(forKey: "bookLanguage") {
      self.bookLanguage = defaultLanguage
    }
    
    if self.bookLanguage == nil {
      self.bookLanguage = self.defaultBookLanguage
      self.selectedLanguageName = self.bookLanguage
    } else {
      self.selectedLanguageName = self.bookLanguage
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.assignBackground()
    self.setMenus()
    self.setBookLanguageSelection()
    
    // Retrieve data from Firebase
    ref.observe(.value, with: { snapshot in
      // todo: put all of these in separate methods.
      self.languages = []
      if let languageSnaps = snapshot.childSnapshot(forPath: "bd_languages").children.allObjects as? [FIRDataSnapshot] {
        for languageSnap in languageSnaps {
          if let languageDictionary = languageSnap.value as? [String: Any] {
            if self.selectedLanguageName != nil {
              if languageDictionary["languageName"] as! String == self.selectedLanguageName {
                self.selectedLanguageKey = languageSnap.key
                let key = languageSnap.key
                let language = Language(key: key, dictionary: languageDictionary)
                self.languages.insert(language, at: 0)
              }
            }
            else {
              let key = languageSnap.key
              let language = Language(key: key, dictionary: languageDictionary)
              self.languages.insert(language, at: 0)
            }
          }
        }
      }
      
      self.books = []
      if let bookSnaps = snapshot.childSnapshot(forPath: "bd_books").children.allObjects as? [FIRDataSnapshot] {
        for bookSnap in bookSnaps {
          if let bookDictionary = bookSnap.value as? [String: Any] {
            if self.selectedLanguageKey != nil {
              if bookDictionary["bookLanguage"] as! String == self.selectedLanguageKey {
                let key = bookSnap.key
                let book = Book(key: key, dictionary: bookDictionary)
                self.books.insert(book, at: 0)
              }
            } else {
              let key = bookSnap.key
              let book = Book(key: key, dictionary: bookDictionary)
              self.books.insert(book, at: 0)
            }
          }
        }
      }
      
      self.roles = []
      if let roleSnaps = snapshot.childSnapshot(forPath: "bd_roles").children.allObjects as? [FIRDataSnapshot] {
        for roleSnap in roleSnaps {
          if let roleDictionary = roleSnap.value as? [String: Any] {
            let key = roleSnap.key
            let role = Role(key: key, dictionary: roleDictionary)
            self.roles.insert(role, at: 0)
          }
        }
      }

      self.contributors = []
      if let contributorSnaps = snapshot.childSnapshot(forPath: "bd_contributors").children.allObjects as? [FIRDataSnapshot] {
        for contributorSnap in contributorSnaps {
          if let contributorDictionary = contributorSnap.value as? [String: Any] {
            let key = contributorSnap.key
            let contributor = Contributor(key: key, dictionary: contributorDictionary)
            self.contributors.insert(contributor, at: 0)
          }
        }
      }
      
      self.collectionView?.reloadData()
    })
  }
  
  func createLanguages(snapshot: FIRDataSnapshot) {}
  func createBooks(snapshot: FIRDataSnapshot) {}
  func createRoles(snapshot: FIRDataSnapshot) {}
  func createContributors(snapshot: FIRDataSnapshot) {}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.books.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let book = books[indexPath.row]
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookCell {
      cell.backgroundColor = UIColor.white
      let coverUrl = storageUrl.appending(book.bookCoverPageUrl)
      var bookCover: UIImage = UIImage()
      if coverUrl.hasPrefix("gs://") {
        FIRStorage.storage().reference(forURL: coverUrl).data(withMaxSize: INT64_MAX) { (data, error) in
          if let error = error {
            print("Error downloading: \(error)")
            return
          }
          bookCover = UIImage.init(data: data!)!
          cell.imageView.image = bookCover
        }
      }
      cell.bookTitleLabel.text = book.bookTitle
      return cell
    } else {
      return BookCell()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let book = books[indexPath.row]
    self.bookDetail = showBookDetail(book: book) as [String: Any]
    performSegue(withIdentifier: "ViewBookDetail", sender: self.bookDetail)
  }
  
  override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
    if segue!.identifier == "ViewBookDetail" {
      if let bookDetailViewController = segue!.destination as? BookDetailViewController {
        bookDetailViewController.bookDetail = sender as? [String: AnyObject]
      }
    }
  }
  
  func loadBookCover(url: String) -> UIImage {
    var bookCover: UIImage = UIImage()
    if url.hasPrefix("gs://") {
      FIRStorage.storage().reference(forURL: url).data(withMaxSize: INT64_MAX) { (data, error) in
        if let error = error {
          print("Error downloading: \(error)")
          return
        }
        bookCover = UIImage.init(data: data!)!
      }
    }
    return bookCover
  }
  
  func showBookDetail(book: Book) -> [String: Any] {
    self.bookDetail["bookKey"] = book.bookKey
    
    var bookLanguage: String!
    for language in self.languages {
      if book.bookLanguage == language.languageKey {
        bookLanguage = language.languageName
      }
    }
    self.bookDetail["bookLanguage"] = bookLanguage as AnyObject?
    
    self.bookDetail["bookCoverPageUrl"] = book.bookCoverPageUrl as AnyObject?
    let coverUrl = storageUrl.appending(book.bookCoverPageUrl)
    let bookCover = loadBookCover(url: coverUrl)
    self.bookDetail["bookCoverPage"] = bookCover as UIImage
    
    self.bookDetail["createdDate"] = book.createdDate as AnyObject?
    self.bookDetail["bookUrl"] = book.bookUrl as AnyObject?

    self.bookDetail["bookTitle"] = book.bookTitle as AnyObject?
    self.bookDetail["bookDescription"] = book.bookDescription as AnyObject?
    
    var contributors = [[String: Any]]()
    var contributorRole = [String: Any]()
    for key in book.contributors.keys {
      for contributor in self.contributors {
        if key == contributor.contributorKey {
          contributorRole["contributorName"] = contributor.name as AnyObject?
          for roleKey in contributor.roles.keys {
            for role in self.roles {
              if roleKey == role.roleKey {
                contributorRole["contributorRole"] = role.name as AnyObject?
              }
            }
          }
        }
      }
      contributors.insert(contributorRole, at: 0)
    }
    self.bookDetail["contributors"] = contributors as AnyObject?
    
    return bookDetail
  }
}

extension BooksViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem + 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
