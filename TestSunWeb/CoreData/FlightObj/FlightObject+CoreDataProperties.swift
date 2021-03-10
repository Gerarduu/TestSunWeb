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
    
    @NSManaged public var id: NSNumber!
    @NSManaged public var airline: String!
    @NSManaged public var departureAirportCode: String!
    @NSManaged public var arrivalAirportCode: String!
    @NSManaged public var price: NSNumber!
    @NSManaged public var outBound: NSNumber!
    @NSManaged public var checked: NSNumber!
    @NSManaged public var visible: NSNumber!
}

extension FlightObject: Transport {
    var transportId: Int {
        get {
            return id.intValue
        }
        set {
            self.id = NSNumber(value: newValue)
        }
    }
    
    var transportPrice: Float {
        get {
            return price.floatValue
        }
        set {
            self.price = NSNumber(value: newValue)
        }
    }
    
    func isConbinableWith(transport: Transport) {
        //
    }
}
