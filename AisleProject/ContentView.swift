//
//  ContentView.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 27/06/25.
//
import SwiftUI

struct ContentView: View {
    @State var countryCode = "+91"
    @State var phNumber = "9876543210"
    @State var number = ""
    @State private var phoneAuthStatus = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Text("Get OTP")
                    .font(.title3)
                
                Text("Enter your phone number")
                    .font(.largeTitle.bold())

                HStack(spacing: 10) {
                    // Country Code
                    TextField("Code", text: $countryCode)
                        .font(.title3.bold())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .frame(width: 70)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)

                    // Phone Number
                    TextField("Phone Number", text: $phNumber)
                        .font(.title3.bold())
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }

                Button{
                    number = (countryCode+phNumber)
                    phoneNumberApiCall(for: number)
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
                
                NavigationLink(destination: OTPView(number: number, countryCode: countryCode, phNumber: phNumber), isActive: $phoneAuthStatus){
                        EmptyView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .onChange(of: phoneAuthStatus){ newValue in
                if newValue {
                    print("Phone Number \(phNumber) verified")
                }
            }
        }
    }

    func phoneNumberApiCall(for number: String) {
        print(number)
        guard let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login") else {
            print("Invalid URL")
            return
        }

        print("Making PHNO API Call...")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["number": number]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Phone Number Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        phoneAuthStatus = true
                    }
                }
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print("✅ Phone Number Response: \(json)")
                } catch {
                    print("⚠️ JSON decode error: \(error)")
                }
            }
        }.resume()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

