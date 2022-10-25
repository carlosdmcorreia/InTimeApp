//
//  ContentView.swift
//  InTimeApp
//
//  Created by Carlos Correia on 18/10/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("appFisrtLaunch") var appFisrtLaunch: Bool = true
    
    var body: some View {
        if appFisrtLaunch {
            FirstLaunchView(appFisrtLaunch: appFisrtLaunch)
        } else {
            TaskListView()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
