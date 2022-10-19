//
//  DateHolder.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject {
    
    init(_ context:  NSManagedObjectContext){
        
    }
    
    func saveContext(_ context:  NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

