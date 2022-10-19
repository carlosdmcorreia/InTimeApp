//
//  FloatingButton.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI

struct FloatingButton: View {
    @State private var showTaskEditView = false
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        HStack{
            Button{
                showTaskEditView.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .padding(15)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(30)
                    .padding(30)
                    .shadow(radius: 3)
            }
        }
        .sheet(isPresented: $showTaskEditView) {
            TaskEditView(passedTaskItem: nil, initialDate: Date())
                .environmentObject(dateHolder)
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton()
    }
}
