//
//  WelcomeView.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/10.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        
        VStack {
            VStack {
                Text("Click Restart button after \n setting privacy Policy to start Switcher").multilineTextAlignment(.center)
            }
            Button("Restart", action: {
                Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["-b", Bundle.main.bundleIdentifier!])
                NSApp.terminate(self)
            })
            .padding(.top, 15.0)
            .padding(.bottom, 10.0)
            .frame(alignment: .leading)
        }.frame(width: 300, height: 300)
    }
}



struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
