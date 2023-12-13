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
    
    enum APIType {
        case json
        case multipart
    }
    
    //MARK: - singleton
    static let shared = APIManager()
    private init() { }
    
    //MARK: - properties
    static let interceptor = RefreshInterceptor(keychainRepository: KeychainRepository())
    static let session = Session(interceptor: interceptor)
    
    //MARK: - methods
    func request<T: Decodable>(
        api: MementoAPI,
        responseType: T.Type,
        isWithToken: Bool = true,
        apiType: APIType = .json
    ) -> Single<APIResult<T>> {
        
        return Single.create { single -> Disposable in
            
            //MARK: - (0-1) Token의 유무 판단
            let provider = isWithToken
            ? MoyaProvider<MementoAPI>(
                session: APIManager.session,
                plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            : MoyaProvider<MementoAPI>(
                plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            
            provider.request(api) { result in
                
                switch result {
                case .success(let response):
                    
                    //MARK: - (1-1) 요청 성공 & multipart -> 응답 코드
                    if apiType == .multipart {
                        return single(.success(.statusCode(response.statusCode)))
                    }
                    
                    let decoder = JSONDecoder()
                    
                    //MARK: - (1-2) 요청 성공 & json 디코딩 성공 -> 디코딩 한 데이터
                    do {
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        single(.success(.suceessData(decodedData)))
                    } catch {
                        //MARK: - (2) 요청 성공 & 디코딩 실패 -> 응답 코드
                        single(.success(.statusCode(response.statusCode)))
                    }
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode
                    else {
                        //MARK: - (3) 요청 실패 & 응답 코드가 없을 때 -> 서버 오류 응답 코드
                        single(.success(.statusCode(NetworkError.internalServerError.rawValue)))
                        return
                    }
                    //MARK: - (4) 요청 실패 -> 응답 코드
                    single(.success(.statusCode(statusCode)))
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
    
    //MARK: - refresh
    func refresh(
        accessToken: String,
        refreshToken: String,
        completion: @escaping ( APIResult<RefreshTokenResponseDTO> ) -> Void
    ) {
        
        let provider = MoyaProvider<MementoAPI>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        let requestDTO = RefreshTokenRequestDTO(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        provider.request(.refreshToken(model: requestDTO)) { result in
            
            let decoder = JSONDecoder()
            
            switch result {
            case .success(let response):
                let status = response.statusCode
                
                do {
                    let decodedData = try decoder.decode(RefreshTokenResponseDTO.self, from: response.data)
                    completion(.suceessData(decodedData))
                } catch {
                    completion(.statusCode(response.statusCode))
                }
                
                if status >= 400 {
                    completion(.statusCode(response.statusCode))
                }
            case .failure(let error):
                completion(.statusCode(error.errorCode))
            }
        }
    }
    
    //MARK: - (3) uploadImage
}
