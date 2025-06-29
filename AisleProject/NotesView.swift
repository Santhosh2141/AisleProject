//
//  NotesView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 28/06/25.
//

import SwiftUI

struct NotesView: View {
    let token: String
    @ObservedObject var otpModel = OTPAuthModel.shared
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
                            .profileInfo(with: "Meena, 23", notes: "Tap to review 50+ notes", addNotes: true)
                    }
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
        .onChange(of: otpModel.isOTPVerified) { verified in
            if verified {
                print(otpModel.token)
                APICalls.apiCall.fetchNotes(with: otpModel.token)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(token: "32c7794d2e6a1f7316ef35aa1eb34541")
    }
}
