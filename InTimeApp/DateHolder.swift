//
//  DateHolder.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject {
    
    @Published var taskItems: [TaskItem] = []
    
    init(_ context:  NSManagedObjectContext){
        taskItems = fetchTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem] {
        do{
            return try context.fetch(dailyTaskFetch()) as [TaskItem]
        } catch let error {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func dailyTaskFetch() -> NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = sortOrder()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completeDate, ascending: true)
        let dateSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        
        return [completedDateSort, dateSort, dueDateSort]
    }
    
    func saveContext(_ context:  NSManagedObjectContext) {
        do {
            taskItems = fetchTaskItems(context)
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

