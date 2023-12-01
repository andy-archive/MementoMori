//
//  APIManager.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/16.
//

import Foundation

import Moya
import RxSwift

final class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    private let provider = MoyaProvider<MementoAPI>()
    
    func validateEmail(email: String) -> Observable<EmailValidationResponseDTO> {
        
        return Observable<EmailValidationResponseDTO>.create { [weak self] observer in
            let data = EmailValidationRequestDTO(email: email)
            
            self?.provider.request(.emailValidation(model: data)) { result in
                switch result {
                case .success(let value):
                    do {
                        let data = try JSONDecoder().decode(EmailValidationResponseDTO.self, from: value.data)
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
    
    func request<T: Decodable>(api: MementoAPI, responseType: T.Type) -> Single<APIResult<T>> {
        
        return Single.create { single -> Disposable in
            
            self.provider.request(api) { result in
                
                let decoder = JSONDecoder()
                
                switch result {
                case .success(let response):
                    do { //1. 요청 성공 및 디코딩 성공 시 -> 디코딩 된 데이터
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        single(.success(.suceessData(decodedData)))
                    } catch { //2. 요청 성공은 했으나 디코딩 실패 -> 응답 코드
                        single(.success(.errorStatusCode(response.statusCode)))
                    }
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode
                    else { //3. 요청 실패, 응답 코드가 없을 때 -> 서버 오류 응답 코드
                        single(.success(.errorStatusCode(NetworkError.internalServerError.rawValue)))
                        return
                    }  //4. 요청 실패, 공통 에러(Network)에 해당할 때 -> 응답 코드
                    single(.success(.errorStatusCode(statusCode)))
                }
            }
            return Disposables.create()
        }
    }
}
