//
//  ToolBarButton.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 29/06/25.
//

import SwiftUI

struct ToolBarButton: View{
    
    var buttonName: String
    var buttonTitle: String
    var isFocussed: Bool
    var amount: String
    
    var body: some View{
        ZStack(alignment: .topTrailing){
            Button{
                
            } label: {
                VStack{
                    Image(systemName: buttonName)
                    Text("\(buttonTitle)")
                }
            }
            if amount != "" {
                Text(amount)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .bold()
            }
        }
        .foregroundColor(isFocussed ? .black : .gray)
    }
}

struct ToolBarButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarButton(buttonName: "envelope.fill", buttonTitle: "Notes", isFocussed: true, amount: "9")
    }
}
