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

    /*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TaskItem>
    */
    
    @State private var showTaskEditView = false
    @State private var showCompleted: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(dateHolder.taskItems) { taskItem in
                            if !taskItem.isCompleted() {
                                TaskCell(passedTaskItem: taskItem)
                                    .environmentObject(dateHolder)
                            }
                            if showCompleted {
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
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                withAnimation{
                                    showCompleted.toggle()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { dateHolder.taskItems[$0] }.forEach(viewContext.delete)
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
