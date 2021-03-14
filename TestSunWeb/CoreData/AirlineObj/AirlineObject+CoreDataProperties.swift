//
//  AirlineObject+CoreDataProperties.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import Foundation
import CoreData

extension AirlineObject {
    
    @nonobjc public class func fetchRequestAirline() -> NSFetchRequest<AirlineObject> {
        return NSFetchRequest<AirlineObject>(entityName: kAirlineEntity)
    }
    
    @NSManaged public var id: String!
    @NSManaged public var name: String!
    @NSManaged public var headline: String!
    @NSManaged public var airlineDesc: String!
    @NSManaged public var logoImg: URL!
    @NSManaged public var mainImg: URL!
}
