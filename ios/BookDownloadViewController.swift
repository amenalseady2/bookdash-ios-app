//
//  BookDownloadViewController.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import SSZipArchive
import SwiftyJSON

class BookDownloadViewController: UICollectionViewController, SSZipArchiveDelegate {
  var bookKey: String!
  var downloadUrl: String!
  var localZipFileDirectory: String!
  var bookFilesDirectory: String!
  var zipFileDownloadRef: FIRStorageReference!
  var localFilePath: String!
  var localFileUrl: URL!
  var bookDirectory: String!
  var bookJSONPath: String!
  
  var dictionary = [String: AnyObject]()
  var bookDownload: BookDownload? {
    didSet {
      dataLoaded = true
      collectionView?.reloadData()
    
    }
  }
  var dataLoaded = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.shouldAutorotate
    //self.forceLandScape()
    
    self.downloadBook()
    collectionView?.reloadData()
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  func downloadBook() {
    // Get a reference to the compressed book file in Firebase Storage
    self.zipFileDownloadRef = storageRef.child(self.downloadUrl)
    
    // Create a local filesystem URL from the file path
    self.getZipFileDirectory()
    
    self.localFilePath = self.localZipFileDirectory.appending(self.bookKey)
    let success = FileManager.default.fileExists(atPath: self.localFilePath) as Bool
    if success == false {
      do {
        try! FileManager.default.createDirectory(atPath: self.localFilePath, withIntermediateDirectories: true, attributes: nil)
      }
    }
    
    self.localFileUrl = URL(fileURLWithPath: self.localFilePath)
    self.bookFilesDirectory = self.getBookFilesDirectory(path: self.localFilePath)
    self.downloadZipFile()
  }
  
  func getZipFileDirectory() {
    // Create a local directory for storing compressed book downloads
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    self.localZipFileDirectory = paths[0].appending("/BookDashZipFiles/")
    let success = FileManager.default.fileExists(atPath: self.localZipFileDirectory) as Bool
    if success == false {
      do {
        try! FileManager.default.createDirectory(atPath: self.localZipFileDirectory, withIntermediateDirectories: true, attributes: nil)
      }
    }
  }
  
  func getBookFilesDirectory(path: String) -> String {
    let localBookFilesDirectory = path.appending(self.bookKey!)
    return localBookFilesDirectory
  }
  
  func downloadZipFile() {
    // Download the compressed book file from Firebase to the local directory
    let downloadTask = zipFileDownloadRef.write(toFile: self.localFileUrl) { url, error in
      if error != nil {
        print(error!)
      } else {
        // Unzip the downloaded file in the local directory
        SSZipArchive.unzipFile(atPath: self.localFilePath, toDestination: self.bookFilesDirectory, delegate: self)
        self.readFile()
      }
    }
    downloadTask.resume()
  }
  
  func readFile() {
    var localDirectoryListing: String!
    do {
      let topDirectoryListing = try FileManager.default.contentsOfDirectory(atPath: self.bookFilesDirectory)
      localDirectoryListing = self.bookFilesDirectory.appending("/" + topDirectoryListing.last!)
    } catch {
      print("Error reading book directory")
    }
    
    do {
      let bookDirectoryListing = try FileManager.default.contentsOfDirectory(atPath: localDirectoryListing)
      do {
        let bookJSON = try FileManager.default.contents(atPath: localDirectoryListing.appending("/bookdetails.json"))
        let json = JSON(data: bookJSON!)
        var pages = [UIImage]()
        for item in json["pages"].arrayValue {
          if (item["pageNumber"].intValue == 0) {
            let coverPageImageFile = localDirectoryListing.appending(item["image"].stringValue)
            if let coverPageImage = UIImage(contentsOfFile: coverPageImageFile) {
              self.dictionary["cover"] = coverPageImage as AnyObject?
            }
          } else {
            let pageImageFile = localDirectoryListing.appending(item["image"].stringValue)
            if let pageImage = UIImage(contentsOfFile: pageImageFile) {
              pages.append(pageImage)
            }
          }
        }
        self.dictionary["pages"] = pages as AnyObject?
        self.bookDownload = BookDownload(dictionary: self.dictionary)
      } catch {
        print("Error reading JSON")
      }
    } catch {
      print("Error downloading book file")
    }
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let bookDownload = self.bookDownload {
      return bookDownload.numberOfPages() + 1
    }
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookDownloadCell", for: indexPath) as! BookDownloadCell
    if indexPath.row == 0 {
      // Cover page
      cell.imageView.image = self.bookDownload?.coverImage()
    } else {
      cell.imageView.image = self.bookDownload?.pageImage(index: indexPath.row - 1)
    }
    return cell
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.landscape
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
