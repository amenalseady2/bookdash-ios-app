//
//  Constants.swift
//  ios
//
//  Created by Marlene Jaeckel on 1/7/17.
//  Copyright © 2017 Book Dash. All rights reserved.
//

import Foundation
import Firebase

let baseUrl = "https://book-dash-a93c3.firebaseio.com"
let storageUrl = "gs://book-dash.appspot.com/"

let ref = FIRDatabase.database().reference()
let storageRef = FIRStorage.storage().reference()

let bookRef = FIRDatabase.database().reference().child("bd_books")
let languageRef = FIRDatabase.database().reference().child("bd_languages")
let contributorRef = FIRDatabase.database().reference().child("bd_contributors")
let roleRef = FIRDatabase.database().reference().child("bd_roles")

let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
let zipFilesDirectory = paths[0].appending("/BookDashZipFiles/")
