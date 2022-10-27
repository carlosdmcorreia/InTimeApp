//
//  TaskEditView.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dateHolder: DateHolder
    
    @State var selectedTaskItem: TaskItem?
    
    @State var name: String
    @State var notes: String
    @State var link: String
    @State var dueDate: Date
    @State var scheduleTime: Bool
    @State var scheduleDate: Bool
    @State var flag: Bool
    
    @State var pkDate: Bool = false
    @State var pkTime: Bool = false
    
    @State var notificationID: String
    
    init(passedTaskItem: TaskItem?, initialDate: Date){
           
        if let taskItem = passedTaskItem{
            // EDIT MODE
            _selectedTaskItem = State(initialValue: taskItem)
            _name = State(initialValue: taskItem.name ?? "")
            _notes = State(initialValue: taskItem.notes ?? "")
            _link = State(initialValue: taskItem.link ?? "")
            _dueDate = State(initialValue: taskItem.dueDate ?? initialDate)
            _scheduleTime = State(initialValue: taskItem.scheduleTime)
            _scheduleDate = State(initialValue: taskItem.scheduleDate)
            _flag = State(initialValue: taskItem.flag)
            _notificationID = State(initialValue: taskItem.notificationID ?? "")
        } else {
            _name = State(initialValue: "")
            _notes = State(initialValue: "")
            _link = State(initialValue: "")
            _dueDate = State(initialValue: initialDate)
            _scheduleTime = State(initialValue: false)
            _scheduleDate = State(initialValue: false)
            _flag = State(initialValue: false)
            _notificationID = State(initialValue: UUID().uuidString)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        TextField("Title", text: $name)
                        TextField("Notes", text: $notes)
                        TextField("URL", text: $link)
                    }
                    
                    Section{
                        Toggle(isOn: $scheduleDate){
                            HStack{
                                Image(systemName: "calendar")
                                    .foregroundColor(Color.white)
                                    .padding(10)
                                    .frame(width: 30, height: 30)
                                    .background(Color.red)
                                    .cornerRadius(5)
                                
                                VStack {
                                    Text("Date")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if scheduleDate {
                                        Button{
                                            pkDate.toggle()
                                            pkTime = false
                                        }label: {
                                            Text(dueDate, style: .date)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }
                        .onChange(of: scheduleDate) { isOn in
                            if isOn {
                                if !pkTime{
                                    pkDate = true
                                    pkTime = false
                                }
                            } else {
                                pkDate = false
                                pkTime = false
                                scheduleTime = false
                            }
                        }
                        .padding(.vertical, 5)
                        
                        if pkDate {
                            DatePicker(selection: $dueDate, in: Date()..., displayedComponents: [.date]){}
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        Toggle(isOn: $scheduleTime){
                            HStack{
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color.white)
                                    .padding(10)
                                    .frame(width: 30, height: 30)
                                    .background(Color.blue)
                                    .cornerRadius(5)
                                
                                VStack {
                                    Text("Hour")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if scheduleTime {
                                        Button{
                                            pkDate = false
                                            pkTime.toggle()
                                        }label: {
                                            Text(dueDate, style: .time)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                    }
                                }
                            }
                        }
                        .onChange(of: scheduleTime) { isOn in
                            if isOn {
                                scheduleTime = true
                                pkTime = true
                                scheduleDate = true
                                pkDate = false
                            } else {
                                pkTime = false
                            }
                        }
                        .padding(.vertical, 5)
                        
                        
                        if pkTime {
                            DatePicker(selection: $dueDate, in: Date()..., displayedComponents: [.hourAndMinute]){}
                                .datePickerStyle(WheelDatePickerStyle())
                        }
                    }
                
                    Section {
                        Toggle(isOn: $flag){
                            HStack{
                                Image(systemName: "flag.fill")
                                    .foregroundColor(Color.white)
                                    .padding(10)
                                    .frame(width: 30, height: 30)
                                    .background(Color.orange)
                                    .cornerRadius(5)
                                
                                Text("Flag")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .animation(Animation.linear(duration: 0.5), value: [scheduleDate, scheduleTime, pkTime, pkDate])
                .navigationBarTitle("Details", displayMode: .inline)
                .navigationBarItems(
                    leading: Button{
                        self.presentationMode.wrappedValue.dismiss()
                    }label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    },
                    trailing:
                        Button("OK", action: saveAction)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .disabled(name.isEmpty)
                )
            }
        }
            
    }
    
    func saveAction(){
        withAnimation {
            
            if(name != ""){
                if selectedTaskItem == nil {
                    selectedTaskItem = TaskItem(context: viewContext)
                }
                
                selectedTaskItem?.created = Date()
                selectedTaskItem?.name = name
                selectedTaskItem?.notes = notes
                selectedTaskItem?.link = link
                selectedTaskItem?.dueDate = dueDate
                selectedTaskItem?.scheduleTime = scheduleTime
                selectedTaskItem?.scheduleDate = scheduleDate
                selectedTaskItem?.flag = flag
                selectedTaskItem?.notificationID = notificationID
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
                
                NotificationManager.instance.scheduleNotification(task: selectedTaskItem!)
                
                dateHolder.saveContext(viewContext)
                
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView(passedTaskItem: TaskItem(), initialDate: Date())
    }
}
