//
//  AirlineManager.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import Foundation
import CoreData
import UIKit

class AirlineManager: NSObject {
    
    static let shared = AirlineManager()
    var persistentContainer: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Could not convert delegate to AppDelegate") }
        return appDelegate.persistentContainer
    }
    
    func saveAirlines(airlines: [Airline], finish: @escaping () -> Void) {
            
        let context = persistentContainer.viewContext
        
        context.perform {
            for airlineModel in airlines {
                let airline = AirlineObject(context: context)
                airline.id = airlineModel.id
                airline.name = airlineModel.name
                airline.headline = airlineModel.headline
                airline.airlineDesc = airlineModel.description
                airline.logoImg = airlineModel.logoImg
                airline.mainImg = airlineModel.mainImg
            }
            
            do {
                finish()
                try context.save()
            } catch let error as NSError {
                debugPrint("Could not save airline. \(error), \(error.userInfo)")
                finish()
            }
        }
    }
    
    func getAirline(id: String) -> AirlineObject? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<AirlineObject>(entityName: kAirlineEntity)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let elem = try? context.fetch(fetchRequest)
        return elem?.first
    }
    
    func deleteAirlines(finish: @escaping () -> Void) {
        let context = persistentContainer.viewContext
        
        context.perform {
            do {
                let elems = try context.fetch(AirlineObject.fetchRequestAirline())
                for elem in elems {
                    context.delete(elem)
                }
                try context.save()
                finish()
            } catch let error as NSError {
                debugPrint("Could not delete flight. \(error), \(error.userInfo)")
                finish()
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
