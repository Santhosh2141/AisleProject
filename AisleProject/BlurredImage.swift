//
//  BlurredImage.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 29/06/25.
//

import SwiftUI

struct BlurredImage: View{
    var imageName: String
    
    var body: some View{
        VStack{
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 175, height: 250)
                .blur(radius: 10)
                .clipped()
                .cornerRadius(15)
                .profileInfo(with: imageName, notes: "", addNotes: false)
        }
    }
}

struct BlurredImage_Previews: PreviewProvider {
    static var previews: some View {
        BlurredImage(imageName: "Teena")
    }
}
