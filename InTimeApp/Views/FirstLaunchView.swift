//
//  FirstLaunchView.swift
//  InTimeApp
//
//  Created by Carlos Correia on 20/10/2022.
//

import SwiftUI

struct FirstLaunchView: View {
    @AppStorage("appFisrtLaunch") var appFisrtLaunch: Bool = true
    
    var body: some View {

        VStack {
            Text("(Page in delopment)")
                .font(.footnote)
            Spacer()
            
            Text("InTime App")
                .font(.largeTitle).bold()
                .foregroundColor(.accentColor)
            Text("This is my first SwiftUI project.")
                .font(.footnote)
            
            Spacer()
            
            
            
            Button {
                NotificationManager.instance.requestAuthorization()
                
                appFisrtLaunch = false
            } label: {
                Text("Start")
            }
        }
        
        
    }
}

struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView(appFisrtLaunch: true)
    }
}
