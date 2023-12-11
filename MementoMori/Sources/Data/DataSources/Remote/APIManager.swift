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
    
    //MARK: - singleton
    static let shared = APIManager()
    private init() { }
    
    //MARK: - properties
    static let interceptor = RefreshInterceptor(keychainRepository: KeychainRepository())
    static let session = Session(interceptor: interceptor)
    
    //MARK: - (1) request
    func request<T: Decodable>(api: MementoAPI, responseType: T.Type) -> Single<APIResult<T>> {
        
        return Single.create { single -> Disposable in
            
            let provider = MoyaProvider<MementoAPI>(session: APIManager.session, plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            
            provider.request(api) { result in
                
                let decoder = JSONDecoder()
                
                switch result {
                case .success(let response):
                    do { //MARK: - 1. 요청 성공 및 디코딩 성공 시 -> 디코딩 한 데이터
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        single(.success(.suceessData(decodedData)))
                    } catch { //MARK: - 2. 요청 성공은 했으나 디코딩 실패 -> 응답 코드
                        single(.success(.errorStatusCode(response.statusCode)))
                    }
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode
                    else { //MARK: - 3. 요청 실패, 응답 코드가 없을 때 -> 서버 오류 응답 코드
                        single(.success(.errorStatusCode(NetworkError.internalServerError.rawValue)))
                        return
                    }  //MARK: - 4. 요청 실패, 공통 에러(Network)에 해당할 때 -> 응답 코드
                    single(.success(.errorStatusCode(statusCode)))
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: - (2-1) validateEmail
    func validateEmail(email: String) -> Observable<EmailValidationResponseDTO> {
        
        return Observable<EmailValidationResponseDTO>.create { observer in
            
            let data = EmailValidationRequestDTO(email: email)
            let provider = MoyaProvider<MementoAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            
            provider.request(.emailValidation(model: data)) { result in
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
    
    //MARK: - (2-2) signin
    func signin<T: Decodable>(api: MementoAPI, responseType: T.Type) -> Single<APIResult<T>> {
        
        return Single.create { single -> Disposable in
            
            let provider = MoyaProvider<MementoAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            
            provider.request(api) { result in
                
                let decoder = JSONDecoder()
                
                switch result {
                case .success(let response):
                    do { //MARK: - 1. 요청 성공 및 디코딩 성공 시 -> 디코딩 한 데이터
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        single(.success(.suceessData(decodedData)))
                    } catch { //MARK: - 2. 요청 성공은 했으나 디코딩 실패 -> 응답 코드
                        single(.success(.errorStatusCode(response.statusCode)))
                    }
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode
                    else { //MARK: - 3. 요청 실패, 응답 코드가 없을 때 -> 서버 오류 응답 코드
                        single(.success(.errorStatusCode(NetworkError.internalServerError.rawValue)))
                        return
                    }  //MARK: - 4. 요청 실패, 공통 에러(Network)에 해당할 때 -> 응답 코드
                    single(.success(.errorStatusCode(statusCode)))
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: - (2-3) refresh
    func refresh(accessToken: String, refreshToken: String, completion: @escaping (APIResult<RefreshTokenResponseDTO>) -> Void) {
        
        let provider = MoyaProvider<MementoAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
        let requestDTO = RefreshTokenRequestDTO(accessToken: accessToken, refreshToken: refreshToken)
        
        provider.request(.refreshToken(model: requestDTO)) { result in
            
            let decoder = JSONDecoder()
            
            switch result {
            case .success(let response):
                let status = response.statusCode
                
                do {
                    let decodedData = try decoder.decode(RefreshTokenResponseDTO.self, from: response.data)
                    completion(.suceessData(decodedData))
                } catch {
                    completion(.errorStatusCode(response.statusCode))
                }
                
                if status >= 400 {
                    completion(.errorStatusCode(response.statusCode))
                }
            case .failure(let error):
                completion(.errorStatusCode(error.errorCode))
            }
        }
    }
}
