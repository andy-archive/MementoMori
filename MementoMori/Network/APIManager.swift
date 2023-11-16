//
//  APIManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let provider = MoyaProvider<MementoAPI>()
    
    func validateEmail(email: String) {
        
        let data = EmailValidationRequest(
            email: email
        )
        
        provider.request(.emailValidation(model: data)) { result in
            switch result {
            case .success(let value):
                print("SUCCESS", value.statusCode, value.data)
                
                do {
                    let value = try JSONDecoder().decode(EmailValidationResponse.self, from: value.data)
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
