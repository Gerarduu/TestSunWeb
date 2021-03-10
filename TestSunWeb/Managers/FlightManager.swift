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
    
    func saveFlights(flights: [Flight], outBound: Bool, finish: @escaping (_: Result<Bool, Error>) -> Void) {
            
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
                finish(Result.success(true))
            } catch let error as NSError {
                debugPrint("Could not save file. \(error), \(error.userInfo)")
                finish(Result.failure(error))
            }
        }
    }
    
    func getFlights() -> [FlightObject]? {
        let context = persistentContainer.viewContext
        let items = try? context.fetch(FlightObject.fetchRequest()) as? [FlightObject]
        return items
    }
    
    func deleteFlight(flight: FlightObject) {
        let context = persistentContainer.viewContext
        context.perform {
            do {
                context.delete(flight)
                try context.save()
            } catch let error as NSError {
                debugPrint("Could not delete file. \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
