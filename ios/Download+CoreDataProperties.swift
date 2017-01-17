//
//  Download+CoreDataProperties.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import CoreData

extension Download {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Download> {
    return NSFetchRequest<Download>(entityName: "Download")
  }
}
