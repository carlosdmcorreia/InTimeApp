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
                ZStack(alignment: .bottom) {
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
                    
                    FloatingButton()
                        .environmentObject(dateHolder)
                }
            }
            .navigationTitle("All")
            .padding(.vertical)
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
