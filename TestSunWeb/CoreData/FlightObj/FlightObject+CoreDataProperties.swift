//
//  FlightObject+CoreDataProperties.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation
import CoreData

extension FlightObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightObject> {
        return NSFetchRequest<FlightObject>(entityName: kFlightEntity)
    }
    
    @NSManaged public var id: NSNumber?
    @NSManaged public var airline: String?
    @NSManaged public var departureAirportCode: String?
    @NSManaged public var arrivalAirportCode: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var outBound: NSNumber?
}

extension FlightObject: Identifiable {
    
}
