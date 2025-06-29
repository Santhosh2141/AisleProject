//
//  OTPView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 28/06/25.
//

import SwiftUI

struct OTPResponse: Decodable {
    let token: String
}

struct OTPView: View {
    
    let number : String
    let countryCode: String
    let phNumber: String
    
    @State private var otp = ""
    @State private var token = ""
    @State private var otpAuthSucces = false
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                HStack{
                    Text("\(countryCode) \(phNumber)")
                        .font(.title3)
                    Image(systemName: "pencil")
                        .font(.title3.bold())
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

                Button{
                   verifyOTP(for: number, otp: otp) { otpToken in
                       DispatchQueue.main.async {
                           if let otpToken {
                               token = otpToken
                               print(token)
                               otpAuthSucces = true
                           } else {
                               print("❌ Failed to verify OTP or extract token")
                           }
                       }
                   }
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
                NavigationLink(destination: NotesView(token: token), isActive: $otpAuthSucces){
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            
//            .onChange(of: phoneAuthStatus){ newValue in
//                if newValue {
//                    print("Phone Number \(phNumber) verified")
//                }
//            }

        }
    }
    
    func verifyOTP(for number: String, otp: String, completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: "https://app.aisle.co/V1/users/verify_otp") else {
            print("❌ Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["number": number, "otp": otp]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Error:", error)
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ No data")
                completion(nil)
                return
            }

            // 🧠 Decode token from JSON
            do {
                let decoded = try JSONDecoder().decode(OTPResponse.self, from: data)
                completion(decoded.token)
            } catch {
                print("⚠️ Decode error:", error)
                print("📥 Raw response:", String(data: data, encoding: .utf8) ?? "Invalid")
                completion(nil)
            }
        }.resume()
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(number: "+919876543212", countryCode: "+91", phNumber: "9876543212")
    }
}
