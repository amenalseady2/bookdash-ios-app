//
//  BookDownloadCell.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import UIKit


class BookDownloadCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  var bookDownload: BookDownload?
  var isRightPage: Bool = false
  var shadowLayer: CAGradientLayer = CAGradientLayer()
  
  override var bounds: CGRect {
    didSet {
      shadowLayer.frame = bounds
    }
  }
  
  var image: UIImage? {
    didSet {
      let topRight = UIRectCorner()
      let bottomRight = UIRectCorner()
      let topLeft = UIRectCorner()
      let bottomLeft = UIRectCorner()
      var corners: UIRectCorner = isRightPage ? [topRight, bottomRight] : [topLeft, bottomLeft]
      imageView.image = image!.imageByScalingAndCroppingForSize(targetSize: bounds.size).imageWithRoundedCornersSize(cornerRadius: 20, corners: corners)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupAntialiasing()
    initShadowLayer()
  }
  
  
  func setupAntialiasing() {
    layer.allowsEdgeAntialiasing = true
    imageView.layer.allowsEdgeAntialiasing = true
  }
  
  func initShadowLayer() {
    var shadowLayer = CAGradientLayer()
    
    shadowLayer.frame = bounds
    shadowLayer.startPoint = CGPoint(x: 0, y: 0.5)
    shadowLayer.endPoint = CGPoint(x: 1, y: 0.5)
    
    self.imageView.layer.addSublayer(shadowLayer)
    self.shadowLayer = shadowLayer
  }
  
  func getRatioFromTransform() -> CGFloat {
    var ratio: CGFloat = 0
    
    var rotationY = CGFloat((layer.value(forKeyPath: "transform.rotation.y")! as AnyObject).floatValue!)
    if !isRightPage {
      var progress = -(1 - rotationY / CGFloat(M_PI_2))
      ratio = progress
    }
      
    else {
      var progress = 1 - rotationY / CGFloat(-M_PI_2)
      ratio = progress
    }
    
    return ratio
  }
  
  func updateShadowLayer(animated: Bool = false) {
    var ratio: CGFloat = 0
    
    // Get ratio from transform. Check BookCollectionViewLayout for more details
    var inverseRatio = 1 - abs(getRatioFromTransform())
    
    if !animated {
      CATransaction.begin()
      CATransaction.setDisableActions(!animated)
    }
    
    if isRightPage {
      // Right page
      shadowLayer.colors = NSArray(objects:
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.45).cgColor,
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40).cgColor,
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55).cgColor
      ) as! [Any]
      shadowLayer.locations = NSArray(objects:
        NSNumber(value: 0.00),
        NSNumber(value: 0.02),
        NSNumber(value: 1.00)
      ) as! [NSNumber]
    } else {
      // Left page
      shadowLayer.colors = NSArray(objects:
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.30).cgColor,
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40).cgColor,
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.50).cgColor,
        UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55).cgColor
      ) as! [Any]
      shadowLayer.locations = NSArray(objects:
        NSNumber(value: 0.00),
        NSNumber(value: 0.50),
        NSNumber(value: 0.98),
        NSNumber(value: 1.00)
      ) as! [NSNumber]
    }
    
    if !animated {
      CATransaction.commit()
    }
  }
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if layoutAttributes.indexPath.item % 2 == 0 {
      // The book's spine is on the left of the page
      layer.anchorPoint = CGPoint(x: 0, y: 0.5)
      isRightPage = true
    } else {
      // The book's spine is on the right of the page
      layer.anchorPoint = CGPoint(x: 1, y: 0.5)
      isRightPage = false
    }
    
    self.updateShadowLayer()
  }
  
}

