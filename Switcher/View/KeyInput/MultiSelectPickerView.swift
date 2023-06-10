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
                            if self.selectedItems.contains(allItems[0]) {
                                self.selectedItems.removeAll(where: { $0 == allItems[0] })
                            }
                            if self.selectedItems.contains(item) {
                                // Previous comment: you may need to adapt this piece
                                self.selectedItems.removeAll(where: { $0 == item })
                            }else if item == allItems[0] {
                                self.selectedItems.removeAll()
                                self.selectedItems.append(item)
                            }else if (item >= 131330 && item <= 131334) { // Shift
                                self.selectedItems.removeAll(where: { $0 >= 131330 && $0 <= 131334 })
                                self.selectedItems.append(item)
                            }else if (item >= 262401 && item <= 270593) { // Ctrl
                                self.selectedItems.removeAll(where: { $0 >= 262401 && $0 <= 270593 })
                                self.selectedItems.append(item)
                            }else if (item >= 524576 && item <= 524640) { // Option
                                self.selectedItems.removeAll(where: { $0 >= 524576 && $0 <= 524640 })
                                self.selectedItems.append(item)
                            }else if (item >= 1048840 && item <= 1048856) { // Command
                                self.selectedItems.removeAll(where: { $0 >= 1048840 && $0 <= 1048856 })
                                self.selectedItems.append(item)
                            } else {
                                self.selectedItems.append(item)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                            if(FlagMaps[item]![0] == FlagMaps[item]![1]) {
                                Text(FlagMaps[item]![0]).frame(width: 200)
                            } else {
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


