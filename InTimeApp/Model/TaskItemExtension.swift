//
//  TaskItemExtension.swift
//  InTimeApp
//
//  Created by Carlos Correia on 19/10/2022.
//

import SwiftUI

extension TaskItem{
    func isCompleted() -> Bool {
        return completeDate != nil
    }
    
    func isOverdue() -> Bool {
        if let due = dueDate{
            return !isCompleted() && scheduleDate && due < Date()
        }
        return false
    }
    
    func overDueColor() -> Color {
        if isCompleted() {
            return .secondary
        }
        return isOverdue() ? .orange : .yellow
    }
    
    func dueDateOnly() -> String {
        if let due = dueDate {
            return due.formatted(.dateTime.day().month())
        }
        return ""
    }
    
    func dueDateHour() -> String {
        if let due = dueDate {
            return due.formatted(.dateTime.day().month().hour().minute())
        }
        return ""
    }
    
}
