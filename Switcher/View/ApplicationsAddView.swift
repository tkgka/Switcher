//
//  ApplicationsAddView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/16.
//

import SwiftUI

struct ApplicationsAddView: View {
    
    @ObservedObject var model = ApplicationModel.shared
    @State var currentlyRunnignApplications: [ApplicationData] = []
    @State var selectedItem:[String] = []
    @State var removingItems:[String] = []
    
    var body: some View {
        HStack{
            VStack{
                Text("Setted_Application") // TODO: -
                ApplicationListView(applications: $model.applications, identifierContainer: $removingItems, backgroundColor: .red)
            }
            VStack{
                Text("Add_Item_Key") // TODO: -
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    ).onTapGesture{
                        let applications = currentlyRunnignApplications.compactMap { application in
                            if selectedItem.contains(application.identifier) {
                                return application
                            }
                            return nil
                        }
                        applications.forEach { application in
                            model.applications.append(application)
                        }
                        selectedItem.removeAll()
                    }
                
                Text("Remove_Item_Key") // TODO: -
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    ).onTapGesture{
                        model.applications.removeAll(where: { removingItems.contains($0.identifier) })
                        removingItems.removeAll()
                    }
            }
            
            
            VStack{
                HStack{
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture{
                            updateCurrentlyRunningApplicationsList()
                        }
                    Spacer()
                    Text("Currently_running_Application") // TODO: -
                    Spacer()
                }
                ApplicationListView(
                    applications: $currentlyRunnignApplications,
                    identifierContainer: $selectedItem,
                    backgroundColor: .blue
                )
            }
        }.frame(width: 750.0, height: 450.0)
            .onAppear {
                updateCurrentlyRunningApplicationsList()
            }
    }
    
    private func updateCurrentlyRunningApplicationsList() {
        currentlyRunnignApplications = CurrentlyActiveApplicationController().currentlyRunningApplications().compactMap({ application in
            let imageData = application.icon?.resized(to: .init(width: 30.0, height: 30.0))?.png
            return ApplicationData(
                identifier: application.bundleIdentifier ?? "",
                imageData: imageData,
                preventedKeys: [.init(flags: [.leftCommand], key: .q), .init(flags: [.rightCommand], key: .q), .init(flags: [.bothCommands], key: .q)],
                mappedKeys: []
            )
        })
    }
}
