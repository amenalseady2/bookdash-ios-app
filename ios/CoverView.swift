//
//  CoverView.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import UIKit

class CoverView: UIView {
  
  var image: UIImage? {
    didSet {
      imageView.image = image
      setNeedsUpdateConstraints()
    }
  }
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  // Views
  fileprivate let titleLabel = UILabel()
  fileprivate let imageView = UIImageView()
  
  fileprivate lazy var downloadView: UIStackView = {
    return CoverView.createDownloadView()
  }()
  
  fileprivate var regularConstraints = [NSLayoutConstraint]()
  fileprivate var compactConstraints = [NSLayoutConstraint]()
  
  fileprivate var aspectRatioConstraint: NSLayoutConstraint?
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: 200)
  }
  
  override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    setup()
    setupConstraints()
  }
  
  func setup() {
    imageView.contentMode = .scaleAspectFit
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 22.0)
    titleLabel.textColor = UIColor.black
    
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(downloadView)
  }
  
  func setupConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    downloadView.translatesAutoresizingMaskIntoConstraints = false
    
    let labelBottom = titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    let imageViewTop = imageView.topAnchor.constraint(equalTo: topAnchor)
    let imageViewBottom = imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor)
    
    let downloadTrailing = downloadView.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    NSLayoutConstraint.activate([imageViewTop, imageViewBottom, labelBottom, downloadTrailing])
    
    imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
    imageView.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
    
    downloadView.axis = .vertical
    
    compactConstraints.append(imageView.centerXAnchor.constraint(equalTo: centerXAnchor))
    compactConstraints.append(titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
    compactConstraints.append(downloadView.topAnchor.constraint(equalTo: topAnchor))
    
    regularConstraints.append(imageView.leadingAnchor.constraint(equalTo: leadingAnchor))
    regularConstraints.append(titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor))
    regularConstraints.append(downloadView.bottomAnchor.constraint(equalTo: bottomAnchor))
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.horizontalSizeClass == .regular {
      NSLayoutConstraint.deactivate(compactConstraints)
      NSLayoutConstraint.activate(regularConstraints)
      downloadView.axis = .horizontal
    } else {
      NSLayoutConstraint.deactivate(regularConstraints)
      NSLayoutConstraint.activate(compactConstraints)
      downloadView.axis = .vertical
    }
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    var aspectRatio: CGFloat = 1
    if let image = image {
      //aspectRatio = image.size.width / image.size.height
      aspectRatio = 1
    }
    
    aspectRatioConstraint?.isActive = false
    aspectRatioConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio)
    aspectRatioConstraint?.isActive = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if bounds.height < downloadView.bounds.height {
      downloadView.alpha = 0
    } else {
      downloadView.alpha = 1
    }
    if imageView.bounds.height < 30 {
      imageView.alpha = 0
    } else {
      imageView.alpha = 1
    }
  }
}

extension CoverView {
  class func createDownloadView() -> UIStackView {
    var icons = [UIImageView]()
    icons.append(UIImageView(image: UIImage(named: "DownloadCloud")))
    
    let downloadView = UIStackView(arrangedSubviews: icons)
    downloadView.translatesAutoresizingMaskIntoConstraints = false
    downloadView.axis = .horizontal
    downloadView.distribution = .equalSpacing
    return downloadView
  }
}
