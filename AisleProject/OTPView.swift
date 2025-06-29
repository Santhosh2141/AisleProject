//
//  OTPView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 28/06/25.
//

import SwiftUI

struct OTPView: View {
    
    let number : String
    let countryCode: String
    let phNumber: String
    
    @State private var otp = ""
    @State private var token = ""
    @State private var otpAuthSucces = false
    @StateObject private var otpModel = OTPAuthModel.shared
    @State private var homePage = false
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                HStack{
                    Text("\(countryCode) \(phNumber)")
                        .font(.title3)
                    Button{
                       homePage = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.title3.bold())
                            .foregroundColor(.black)
                    }
                    NavigationLink(destination:  ContentView(newPhoneNumber: PhoneNumber(countryCode: "", phNumber: "", number: "", phoneAuthStatus: false)), isActive: $homePage){
                        EmptyView()
                    }

                }
                
                VStack(alignment: .leading,spacing: 0){
                    Text("Enter your")
                    Text("OTP")
                }
                .font(.largeTitle.bold())
                
                TextField("OTP", text: $otp)
                    .font(.title3.bold())
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .frame(width: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                Button{
                    APICalls.apiCall.verifyOTP(for: number, otp: otp)
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
                NavigationLink(destination: NotesView(token: otpModel.token), isActive: $otpModel.isOTPVerified){
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(number: "+919876543212", countryCode: "+91", phNumber: "9876543212")
    }
}
