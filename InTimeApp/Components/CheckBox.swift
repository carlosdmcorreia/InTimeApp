//
//  CheckBox.swift
//  InTimeApp
//
//  Created by Carlos Correia on 19/10/2022.
//

import SwiftUI

struct CheckBox: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    var body: some View {
        
        Image(systemName: passedTaskItem.isCompleted() ? "circle.inset.filled" : "circle")
            .foregroundColor(passedTaskItem.isCompleted() ? .accentColor : .secondary)
            .font(.title2)
            .onTapGesture {
                withAnimation {
                    if !passedTaskItem.isCompleted(){
                        passedTaskItem.completeDate = Date()
                        dateHolder.saveContext(viewContext)
                    } else {
                        passedTaskItem.completeDate = nil
                        dateHolder.saveContext(viewContext)
                    }
                }
            }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        CheckBox(passedTaskItem: TaskItem())
    }
}
