//
//  NotesView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 28/06/25.
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
    }}

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
        }
        .profileInfo(with: imageName, notes: "", addNotes: false)
    }
}

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
                    .padding(.vertical, 5)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
        }
        .foregroundColor(isFocussed ? .black : .gray)
    }
}

struct NotesView: View {
    let token: String
    
    var body: some View {
        NavigationStack{
//            ScrollView{
                VStack{
                    Text("Notes")
                        .font(.largeTitle.bold())
                    Text("Personal messages to you")
                        .font(.title3)
                    ZStack {
                        Image("Meena")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                            .cornerRadius(15)
                    }
                    .profileInfo(with: "Meena, 23", notes: "Tap to review 50+ notes", addNotes: true)
                    HStack{
                        VStack(alignment: .leading, spacing: 0){
                            Text("Interested in You")
                                .font(.title.bold())
                            Text("Premium members can view all their likes at once")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 10)
                        Button{
                            
                        } label: {
                            Text("Upgrade")
                                .font(.headline)
                                .frame(width: 80)
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.primary)
                                .cornerRadius(30)
                        }
                        //                    .padding(.horizontal)
                    }
                    HStack(alignment: .center, spacing: 10){
                        BlurredImage(imageName: "Teena")
                        BlurredImage(imageName: "Beena")
                    }
                    .padding(0)
                    .padding(.bottom, 20)
                    Spacer()
                }
                .padding(.horizontal,10)
                .padding(.top, 0)
                
//            }
            .toolbar{
                ToolbarItemGroup(placement: .bottomBar){
                    Spacer()
                    ToolBarButton(buttonName: "square.grid.2x2.fill", buttonTitle: "Discover", isFocussed: false, amount: "")
                    Spacer()
                    ToolBarButton(buttonName: "envelope.fill", buttonTitle: "Notes", isFocussed: true, amount: "9")
                    Spacer()
                    ToolBarButton(buttonName: "bubble.left.fill", buttonTitle: "Matches", isFocussed: false, amount: "50+")
                    Spacer()
                    ToolBarButton(buttonName: "person.fill", buttonTitle: "Profile", isFocussed: false, amount: "")
                    Spacer()
                }
            }
        }
        .onAppear{
            fetchNotes(with: token)
        }
        .navigationBarBackButtonHidden(true)
        
    }
    func fetchNotes(with authToken: String) {
        guard let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list") else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authToken, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Request failed:", error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Notes Status code:", httpResponse.statusCode)
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("✅ Notes response:", json)
                } catch {
                    print("⚠️ Failed to parse JSON:", error)
                }
            } else {
                print("❌ No data received")
            }
        }.resume()
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(token: "32c7794d2e6a1f7316ef35aa1eb34541")
    }
}
