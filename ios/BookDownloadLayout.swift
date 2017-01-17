//
//  BookDownloadLayout.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import UIKit

// TODO: Need to investigate this to get the ratios better than dynamic
//private let PageWidth: CGFloat = 362
//private let PageHeight: CGFloat = 568

private let PageWidth = UIScreen.main.bounds.size.width * 0.5
private let PageHeight = UIScreen.main.bounds.size.height * 0.75

class BookDownloadLayout: UICollectionViewFlowLayout {
  var numberOfItems = 0
  
  override func prepare() {
    super.prepare()
    if #available(iOS 10, *) {
      collectionView?.isPrefetchingEnabled = false
    }
    collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
    numberOfItems = collectionView!.numberOfItems(inSection: 0)
    collectionView?.isPagingEnabled = true
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override var collectionViewContentSize: CGSize {
    let width = (CGFloat(numberOfItems / 2)) * collectionView!.bounds.width
    let height = collectionView!.bounds.height
    let insets = UIEdgeInsetsMake(20, 0, 0, 0)
    collectionView!.contentInset = insets
    
    return CGSize(width: width, height: height)
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
    var array: [UICollectionViewLayoutAttributes] = []
    for i in 0 ... max(0, numberOfItems - 1) {
      var indexPath = IndexPath(item: i, section: 0)
      if let attributes = layoutAttributesForItem(at: indexPath) {
        if attributes != nil {
          array += [attributes]
        }
      }
    }
    return array
  }
  
  func getFrame(collectionView: UICollectionView) -> CGRect {
    var frame = CGRect()
    
    frame.origin.x = (collectionView.bounds.width / 2) - (PageWidth / 2) + collectionView.contentOffset.x
    frame.origin.y = ((collectionViewContentSize.height - PageHeight) / 2) * 1.25
    frame.size.width = PageWidth
    frame.size.height = PageHeight
    
    return frame
  }
  
  // adjusting the ratios below .5 can help the book angle
  func getRatio(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGFloat {
    //Ensures that adjacent pages stick together to form a double sided page.
    let page = CGFloat(indexPath.item - indexPath.item % 2) * 0.5
    var ratio: CGFloat = -0.5 + page - (collectionView.contentOffset.x / collectionView.bounds.width)
    
    if ratio > 0.5 {
      ratio = 0.5 + 0.1 * (ratio - 0.5)
    }
    
    if ratio < -0.5 {
      ratio = -0.5 + 0.1 * (ratio + 0.5)
    }
    
    return ratio
  }
  
  func getAngle(indexPath: NSIndexPath, ratio: CGFloat) -> CGFloat {
    var angle: CGFloat = 0
    
    if indexPath.item % 2 == 0 {
      // Spine is on the left of the page
      angle = (1-ratio) * CGFloat(-M_PI_2)
    }
    if indexPath.item % 2 == 1 {
      // Spine is on the right of the page
      angle = (1 + ratio) * CGFloat(M_PI_2)
    }
    // Ensure that odd and even page don't have the same angle
    angle += CGFloat(indexPath.row % 2) / 1000
    return angle
  }
  
  func makePerspectiveTransform() -> CATransform3D {
    var transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -2000;
    return transform;
  }
  
  func getRotation(indexPath: NSIndexPath, ratio: CGFloat) -> CATransform3D {
    var transform = makePerspectiveTransform()
    var angle = getAngle(indexPath: indexPath, ratio: ratio)
    transform = CATransform3DRotate(transform, angle, 0, 1, 0)
    
    return transform
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    var layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    
    // Set initial frame to align the page's edge to the spine
    var frame = getFrame(collectionView: collectionView!)
    layoutAttributes.frame = frame
    
    var ratio = getRatio(collectionView: collectionView!, indexPath: indexPath as NSIndexPath)
    
    // Back-face culling - display only front-face pages.
    if ratio > 0 && indexPath.item % 2 == 1
      || ratio < 0 && indexPath.item % 2 == 0 {
      // Make sure the cover is always visible
      if indexPath.row != 0 {
        return nil
      }
    }
    
    // Apply rotation transform
    var rotation = getRotation(indexPath: indexPath as NSIndexPath, ratio: min(max(ratio, -1), 1))
    layoutAttributes.transform3D = rotation
    
    // Make sure the cover is always above page 1 to avoid flickering when closing the book
    if indexPath.row == 0 {
      layoutAttributes.zIndex = Int.max
    }
    
    return layoutAttributes
  }
}
