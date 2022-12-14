//
//  TaskListView.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedFilter = TaskFilter.All
    
    @State private var showTaskEditView = false
    @State private var showCompleted: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if filteredTaskItems().isEmpty {
                    Spacer()
                    Text("\(selectedFilter.rawValue) tasks completed")
                        .foregroundColor(Color.gray)
                } else {
                    List {
                        ForEach(filteredTaskItems()) { taskItem in
                            if !taskItem.isCompleted() {
                                TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            }
                            if showCompleted || selectedFilter == TaskFilter.OnlyCompleted {
                                if taskItem.isCompleted(){
                                    TaskCell(passedTaskItem: taskItem)
                                        .environmentObject(dateHolder)
                                        .opacity(0.5)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(.plain)
                    .background(Color.clear)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("Picker", selection: $selectedFilter.animation()){
                                ForEach(TaskFilter.allFilters, id: \.self){ filter in
                                    Text(filter.rawValue)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                        
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                withAnimation{
                                    showCompleted.toggle()
                                }
                            } label: {
                                Image(systemName: !showCompleted ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                                    .font(.title3)
                            }
                        }
                    }
                }
                Spacer()
                FloatingButton()
                    .environmentObject(dateHolder)
                
            }
            .navigationTitle("Reminders")
            .padding(.vertical)
        }
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
    }
    
    private func filteredTaskItems() -> [TaskItem] {
        if selectedFilter == TaskFilter.Today {
            return dateHolder.taskItems.filter{$0.isToday()}
        }
        if selectedFilter == TaskFilter.Schedule {
            return dateHolder.taskItems.filter{$0.scheduleDate}
        }
        if selectedFilter == TaskFilter.OverDue {
            return dateHolder.taskItems.filter{$0.isOverdue()}
        }
        if selectedFilter == TaskFilter.Flagged {
            return dateHolder.taskItems.filter{$0.flag}
        }
        if selectedFilter == TaskFilter.OnlyCompleted {
            return dateHolder.taskItems.filter{$0.isCompleted()}
        }
        
        return dateHolder.taskItems
    }
    
    private func deleteItems(offsets: IndexSet) {
        let tasksToDelete = offsets.map { filteredTaskItems()[$0] }
        
        // Remove notifications
        tasksToDelete.forEach { task in UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.notificationID!])
        }

        withAnimation {
            offsets.map { filteredTaskItems()[$0] }.forEach(viewContext.delete)
            dateHolder.saveContext(viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
