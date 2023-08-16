//
//  ApplicationListView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/16.
//

import SwiftUI

struct ApplicationListView: View {
    @Binding var applications: [ApplicationData]
    @Binding var identifierContainer: [String]
    var backgroundColor: Color
    var body: some View {
        List {
            ForEach(applications, id: \.self) { application in
                if let iconData = application.imageData,
                   let icon = NSImage(data: iconData) {
                    HStack{
                        Image(nsImage: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(application.identifier)
                        Spacer()
                    }
                    .background(identifierContainer.contains(application.identifier) ? backgroundColor.opacity(0.5) : nil)
                    .onTapGesture{
                        if(!identifierContainer.contains(application.identifier)) {
                            identifierContainer.append(application.identifier)
                        }else{
                            identifierContainer.removeAll(where: {$0 == application.identifier})
                        }
                    }
                }
            }
        }
    }
}
