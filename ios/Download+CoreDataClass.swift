//
//  Download+CoreDataClass.swift
//  ios
//
//  Created by Marlene Jaeckel.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import CoreData

public class Download: NSManagedObject {
  @NSManaged var bookTitle: String?
  @NSManaged var bookUrl: String?
  @NSManaged var coverPageUrl: String?
  @NSManaged var downloadUrl: String?
}
