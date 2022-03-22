//
//  MultiSelectPickerView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/03/01.
//

import SwiftUI

struct MultiSelectPickerView: View {
    // The list of items we want to show
    @State var allItems: [UInt]
    @Binding var selectedItems: [UInt]
    var body: some View {
        Form {
            List {
                ForEach(allItems, id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            if self.selectedItems.contains(item) {
                                // Previous comment: you may need to adapt this piece
                                self.selectedItems.removeAll(where: { $0 == item })
                            }else if item == allItems[0]{
                                self.selectedItems.removeAll()
                                self.selectedItems.append(item)
                            }else if self.selectedItems.contains(allItems[0]){
                                self.selectedItems.removeAll(where: { $0 == allItems[0] })
                                self.selectedItems.append(item)
                            } else {
                                self.selectedItems.append(item)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                            if(FlagMaps[item]![0] == FlagMaps[item]![1]){
                                Text(FlagMaps[item]![0]).frame(width: 200)
                            }else{
                                Text(FlagMaps[item]![1] + FlagMaps[item]![0]).frame(width: 200)
                            }
                            
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }.frame(width: 300, height: 200)
    }
}


