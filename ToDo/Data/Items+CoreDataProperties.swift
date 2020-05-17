//
//  Items+CoreDataProperties.swift
//  ToDo
//
//  Created by Engin KUK on 18.05.2020.
//  Copyright © 2020 Engin KUK. All rights reserved.
//
//

import Foundation
import CoreData


extension Items {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Items> {
        return NSFetchRequest<Items>(entityName: "Items")
    }

    @NSManaged public var notes: String
    @NSManaged public var done: Bool
    @NSManaged public var name: String

}
