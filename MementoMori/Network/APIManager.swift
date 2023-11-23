//
//  APIManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya
import RxSwift

enum Result<T: Decodable> {
    case success(T)
    case failure(NetworkError)
}

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let provider = MoyaProvider<MementoAPI>()
    
    func validateEmail(email: String) -> Observable<EmailValidationResponse> {
        
        return Observable<EmailValidationResponse>.create { [weak self] observer in
            let data = EmailValidationRequest(email: email)
            
            self?.provider.request(.emailValidation(model: data)) { result in
                switch result {
                case .success(let value):
                    do {
                        let data = try JSONDecoder().decode(EmailValidationResponse.self, from: value.data)
                        observer.onNext(data)
                    } catch {
                        observer.onError(error)
                    }
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func request<Model: Decodable>(api: MementoAPI) -> Single<Result<Model>> {
        
        return Single<Result<Model>>.create { single -> Disposable in
            
            self.provider.request(api) { result in
                
                let decoder = JSONDecoder()
                
                switch result {
                case .success(let value):
                    
                    do {
                        let data = try decoder.decode(Model.self, from: value.data)
                        single(.success(.success(data)))
                    } catch {
                        single(.success(.failure(NetworkError.noResponse)))
                    }
                    
                case .failure(_):
                    single(.success(.failure(NetworkError.internalServerError)))
                }
            }
            
            return Disposables.create()
        }
    }
}
