//
//  ContentView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 27/06/25.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var authModel = PhoneAuthModel.shared
    @State var newPhoneNumber: PhoneNumber
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Text("Get OTP")
                    .font(.title3)
                
                Text("Enter your phone number")
                    .font(.largeTitle.bold())

                HStack(spacing: 10) {
                    TextField("Code", text: $newPhoneNumber.countryCode)
                        .font(.title3.bold())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .frame(width: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                    TextField("Phone Number", text: $newPhoneNumber.phNumber)
                        .font(.title3.bold())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Button{
                    newPhoneNumber.number = (newPhoneNumber.countryCode+newPhoneNumber.phNumber)
                    APICalls.apiCall.phoneNumberApiCall(for: newPhoneNumber.number)
    //                print(number)
                } label: {
                    Text("Continue")
                        .font(.title3.bold())
                        .frame(width: 100)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.primary)
                        .cornerRadius(30)
                }
                .padding(.top, 10)
                Spacer()
                Spacer()
                NavigationLink(destination: OTPView(number: newPhoneNumber.number, countryCode: newPhoneNumber.countryCode, phNumber: newPhoneNumber.phNumber), isActive: $authModel.phoneAuthStatus){
                        EmptyView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .onChange(of: newPhoneNumber.phoneAuthStatus){ newValue in
                if newValue {
                    print("Phone Number \(newPhoneNumber.number) verified")
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(newPhoneNumber: PhoneNumber(countryCode: "+91", phNumber: "9876543212", number: "+919876543212", phoneAuthStatus: true))
    }
}

