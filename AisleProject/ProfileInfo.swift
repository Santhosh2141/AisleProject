//
//  ProfileInfo.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 29/06/25.
//

import SwiftUI

struct ProfileInfo: ViewModifier{
    var name: String
    var notes: String
    var addNotes: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomLeading){
            content
            VStack(alignment: .leading){
                Text(name)
                    .foregroundColor(.white)
                    .font(.title.bold())
                if addNotes{
                    Text(notes)
                        .foregroundColor(.white)
                        .font(.title3.bold())
                }
            }
            .padding(10)
        }
    }
}

extension View{
    func profileInfo(with name: String, notes: String, addNotes: Bool ) -> some View{
        modifier(ProfileInfo(name: name, notes: notes, addNotes: addNotes))
    }
}

struct ProfileInfo_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray
            .frame(width: 300, height: 200)
            .profileInfo(with: "Meena", notes: "Tap to review 50+ notes", addNotes: true)
    }
}
