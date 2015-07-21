//
//  Decisions.swift
//  MingUrap
//
//  Created by Chris Zhang on 7/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import CoreData

class Decisions: NSManagedObject {

    @NSManaged var gameNumber: NSNumber
    @NSManaged var userOffer: NSNumber
    @NSManaged var aiReponse: NSNumber
    @NSManaged var userResponse: NSNumber

}
