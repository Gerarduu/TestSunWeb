//
//  FlightManager.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation
import CoreData

class FlightManager: NSObject {
    
    static let shared = FlightManager()
    private var flightEntity: NSEntityDescription?
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: kContainer)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
    
    func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
