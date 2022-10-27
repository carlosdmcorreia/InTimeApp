//
//  TaskCell.swift
//  InTimeApp
//
//  Created by Carlos Correia on 19/10/2022.
//

import SwiftUI

struct TaskCell: View {
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    @State private var showTaskEditView = false
    
    var body: some View {
        HStack(alignment: .center){
            CheckBox(passedTaskItem: passedTaskItem)
                .environmentObject(dateHolder)
                .padding()
            
            VStack(alignment: .leading){
                Text(passedTaskItem.name ?? "")
                    .frame(alignment: .leading)
                
                if passedTaskItem.notes != "" {
                    Text(passedTaskItem.notes ?? "")
                        .font(.footnote)
                        .lineLimit(1)
                        .frame(alignment: .leading)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 5)
            Spacer()
            
            VStack(alignment: .trailing) {
                if passedTaskItem.flag {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.orange)
                        .font(.footnote)
                }
                if passedTaskItem.scheduleDate{
                    if passedTaskItem.scheduleTime {
                        Text(passedTaskItem.dueDateHour())
                            .font(.footnote)
                            .foregroundColor(passedTaskItem.overDueColor())
                    } else {
                        Text(passedTaskItem.dueDateOnly())
                            .font(.footnote)
                            .foregroundColor(passedTaskItem.overDueColor())
                    }
                }
            }
            
            Image(systemName: "info.circle")
                .padding()
                .foregroundColor(.accentColor)
                .font(.title3)
                .onTapGesture {
                    showTaskEditView.toggle()
                }
            
        }
        .frame(height: 40)
        .sheet(isPresented: $showTaskEditView) {
            TaskEditView(passedTaskItem: passedTaskItem, initialDate: Date())
                .environmentObject(dateHolder)
        }
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(passedTaskItem: TaskItem())
    }
}
