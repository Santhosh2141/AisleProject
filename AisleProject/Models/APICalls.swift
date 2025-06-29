//
//  APICalls.swift
//  AisleProject
//
//  Created by Santhosh Srinivas on 29/06/25.
//

import Foundation

class PhoneAuthModel: ObservableObject {
    static let shared = PhoneAuthModel()
    
    @Published var phoneAuthStatus = false
    
    private init() {}
}

class OTPAuthModel: ObservableObject {
    static let shared = OTPAuthModel()
    
    @Published var isOTPVerified = false
    @Published var token = ""
    
    private init() {}
}

class APICalls{
    static let apiCall = APICalls()
    private init() {}
    
    func phoneNumberApiCall(for number: String) {
        print(number)
        guard let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["number": number]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Phone Number Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        PhoneAuthModel.shared.phoneAuthStatus = true
                    }
                }
            }
        }.resume()
    }

    func verifyOTP(for number: String, otp: String) {
        
        guard let url = URL(string: "https://app.aisle.co/V1/users/verify_otp") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["number": number, "otp": otp]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error:", error)
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(OTPResponse.self, from: data)
                DispatchQueue.main.async {
                    OTPAuthModel.shared.token = decoded.token
                    OTPAuthModel.shared.isOTPVerified = true
                }
            } catch {
                print("Decode error:", error)
                print("Raw response:", String(data: data, encoding: .utf8) ?? "Invalid")
            }
        }.resume()
    }

    func fetchNotes(with authToken: String) {
        guard let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed:", error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Notes Status code:", httpResponse.statusCode)
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Notes response:", json)
            } catch {
                print("Failed to parse JSON:", error)
            }
        }.resume()
    }
}
