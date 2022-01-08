//
//  MenuView.swift
//  TestMenu (iOS)
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI

struct MenuView: View {
    @Namespace var animation
    @State var currentTab = " Uploads "
    var body: some View {
        VStack{
            HStack{
                TabButton(title: " Help ", animation:animation, currentTab: $currentTab)
                TabButton(title: " Uploads ", animation:animation, currentTab: $currentTab)
            }
            .padding(.horizontal)
            .padding(.top)
//            Image("box")
//                .resizable()
//                .aspectRatio(ContentMode: .fit)
//                .padding(25)
            Spacer(minLength: 0)
        }
        .frame(width: 250, height: 300)

    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}

struct TabButton: View {
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String

    var body: some View{
        Button(action:{
            withAnimation {
                currentTab = title
            }
        }, label: {
        Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(currentTab == title ? .white : .primary)
                .padding(.vertical,4)
                .background(
                    ZStack{
                        if currentTab == title{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                        else{
                            RoundedRectangle(cornerRadius: 4).stroke(Color.primary,lineWidth: 1)
                        }
                    })
                .contentShape(RoundedRectangle(cornerRadius: 0.4))
        })
            .buttonStyle(PlainButtonStyle())
    }

}




