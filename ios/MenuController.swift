//
//  MenuController.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation

class MenuController: UITableViewController {
  var bookLanguage: String!
  let segueIdentifiers = ["AllBookLanguages", "Setswana", "Xitsonga", "isiXhosa", "English", "isiNdebele", "Afrikaans",
                          "isiZulu", "Sesotho", "Tshivenda", "Sepedi", "Siswati", "French"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.assignBackground()
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

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    for segueIdentifier in self.segueIdentifiers {
      if segueIdentifier == segue.identifier {
        self.bookLanguage = segueIdentifier
        
        let defaults = UserDefaults.standard
        defaults.set(self.bookLanguage, forKey: "bookLanguage")
        
        let navigationViewController = segue.destination as! UINavigationController
        let booksViewController = navigationViewController.viewControllers.first as! BooksViewController
        booksViewController.bookLanguage = self.bookLanguage
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

