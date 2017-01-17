//
//  BookDetailViewController.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class BookDetailViewController: UIViewController {
  @IBOutlet var bookCoverImageView: UIImageView!
  @IBOutlet var downloadButton: UIButton!
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var createdDateLabel: UILabel!
  @IBOutlet var bookDescriptionLabel: UILabel!

  var bookDetail: [String: AnyObject]!
  var downloadUrl: String!
  var bookTitle: String!
  var coverPageUrl: String!
  var bookCover: UIImage = UIImage()
  var createdDate: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.shouldAutorotate
    
    self.loadBookData(bookDetail: bookDetail)
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    //self.assignBackground()
    //self.forcePortrait()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
  }

  func assignBackground() {
    let background = UIImage(named: "Background")
    let imageView: UIImageView = UIImageView(frame: view.bounds)
    imageView.contentMode =  UIViewContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = background
    imageView.center = view.center
    self.view.addSubview(imageView)
    self.view.sendSubview(toBack: imageView)
  }
  
  func loadBookData(bookDetail: [String: AnyObject]) {
    let bookCoverPageUrl = bookDetail["bookCoverPageUrl"] as! String
    self.coverPageUrl = storageUrl.appending(bookCoverPageUrl)
    self.loadBookCover(url: self.coverPageUrl)
    
    let bookCreatedDate = bookDetail["createdDate"] as! NSNumber
    let epochTime = TimeInterval(bookCreatedDate)/1000
    let unixTimestamp = Date(timeIntervalSince1970: epochTime)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    self.createdDate = dateFormatter.string(from: unixTimestamp)
    self.createdDateLabel.text = self.createdDate
    
    let bookDownloadUrl = bookDetail["bookUrl"] as! String
    self.downloadUrl = bookDownloadUrl
    
    self.bookTitle = bookDetail["bookTitle"] as! String
    self.bookTitleLabel.text = self.bookTitle
    
    let bookDescription = bookDetail["bookDescription"] as! String
    self.bookDescriptionLabel.text = bookDescription
    //let bookContributors = bookDetail["contributors"] as! [[String: String]]
  }
  
  func loadBookCover(url: String) {
    if url.hasPrefix("gs://") {
      FIRStorage.storage().reference(forURL: url).data(withMaxSize: INT64_MAX) { (data, error) in
        if let error = error {
          print("Error downloading: \(error)")
          return
        }
        self.bookCover = UIImage.init(data: data!)!
        self.bookCoverImageView.image = self.bookCover
      }
    }
  }
  
  @IBAction func downloadBook(sender: AnyObject?) {
    performSegue(withIdentifier: "BookDownload", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "BookDownload" {
      let bookDownloadViewController = segue.destination as! BookDownloadViewController
      bookDownloadViewController.downloadUrl = self.downloadUrl as String
    }
  }
  
//  func forcePortrait() {
//    let width = UIScreen.main.bounds.size.width
//    let height = UIScreen.main.bounds.size.height
//    let isLandscape = width > height
//    if isLandscape{
//      var device = UIDevice.current
//      let number = NSNumber(value: Int32(UIInterfaceOrientation.portrait.rawValue))
//      device.setValue(number, forKey: "orientation")
//    }
//  }
//  
//  func forceLandScape() {
//    let width = UIScreen.main.bounds.size.width
//    let height = UIScreen.main.bounds.size.height
//    let isLandscape = width < height
//    if isLandscape{
//      var device = UIDevice.current
//      let number = NSNumber(value: UIInterfaceOrientation.landscapeRight.rawValue)
//      device.setValue(number, forKey: "orientation")
//    }
//  }
}





