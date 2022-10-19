//
//  TaskFilter.swift
//  InTimeApp
//
//  Created by Carlos Correia on 19/10/2022.
//

import SwiftUI

enum TaskFilter: String {
    static var allFilters: [TaskFilter] {
        return [.All, .Today, .Schedule, .OverDue, .Flagged, .OnlyCompleted]
    }

    case All = "All"
    case OnlyCompleted = "Only Completed"
    case Today = "Today"
    case Schedule = "Schedule"
    case OverDue = "Overdue"
    case Flagged = "Flagged"
}
