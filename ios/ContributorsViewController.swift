//
//  ContributorsViewController.swift
//  BookDash
//
//  Created by Marlene Jaeckel.
//  Copyright © 2016 Book Dash. All rights reserved.
//

import Foundation

class ContributorsViewController: UIViewController {
  @IBOutlet weak var textView: UITextView!
   @IBOutlet var menuButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.assignBackground()
    
    if revealViewController() != nil {
      menuButton.target = revealViewController()
      menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
      view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
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
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

}
