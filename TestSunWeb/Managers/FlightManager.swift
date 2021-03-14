//
//  FlightManager.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation
import CoreData
import UIKit

class FlightManager: NSObject {
    
    static let shared = FlightManager()
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Could not convert delegate to AppDelegate") }
        return appDelegate.persistentContainer
    }
    
    func saveFlights(flights: [Flight], outBound: Bool, finish: @escaping () -> Void) {
            
        let context = persistentContainer.viewContext
        
        context.perform {
            for flightModel in flights {
                let flight = FlightObject(context: context)
                flight.transportId = flightModel.id as Int
                flight.airline = flightModel.airline
                flight.departureAirportCode = flightModel.departureAirportCode
                flight.arrivalAirportCode = flightModel.arrivalAirportCode
                flight.transportPrice = flightModel.price as Float
                flight.outBound = outBound ? 1 : 0 /// 1 = true, 0 = false
                flight.checked = 0
                flight.visible = 1
            }
            
            do {
                try context.save()
                finish()
            } catch let error as NSError {
                debugPrint("Could not save flight. \(error), \(error.userInfo)")
                finish()
            }
        }
    }
    
    func getFlights() -> [FlightObject]? {
        let context = persistentContainer.viewContext
        let items = try? context.fetch(FlightObject.fetchRequest()) as? [FlightObject]
        return items
    }
    
    func deleteFlight(id: Int) {
        
        let context = persistentContainer.viewContext
        
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: kFlightEntity)
                fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
                let elem = try context.fetch(fetchRequest)
                
                let elemToDelete = elem[0]
                context.delete(elemToDelete)
                
                try context.save()
            } catch let error as NSError {
                debugPrint("Could not delete flight. \(error), \(error.userInfo)")
            }
        }
    }
}
