//
//  APIManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya
import RxSwift

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let provider = MoyaProvider<MementoAPI>()
    
    func validateEmail(email: String) -> Observable<EmailValidationResponse> {
        
        return Observable<EmailValidationResponse>.create { [weak self] observer in
            let data = EmailValidationRequest(
                email: email
            )
            
            self?.provider.request(.emailValidation(model: data)) { result in
                switch result {
                case .success(let value):
                    print("SUCCESS", value.statusCode, value.data)
                    
                    do {
                        let data = try JSONDecoder().decode(EmailValidationResponse.self, from: value.data)
                        print(data, "--------------------------------")
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
}
