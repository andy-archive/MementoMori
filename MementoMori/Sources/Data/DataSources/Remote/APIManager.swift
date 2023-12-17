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
    
    //MARK: - Singleton
    static let shared = APIManager()
    private init() { }
    
    //MARK: - Properties
    static let interceptor = RefreshInterceptor.shared
    static let session = Session(interceptor: interceptor)
    
    //MARK: - Methods
    func request<T: Decodable>(
        api: MementoAPI,
        responseType: T.Type,
        isWithToken: Bool = true,
        apiType: APIType = .json
    ) -> Single<APIResult<T>> {
        
        return Single.create { single -> Disposable in
            
            let provider = isWithToken ?
            
            //MARK: - (0-1) Token 있는 경우 -> Interceptor Session 적용
            MoyaProvider<MementoAPI>(
                session: APIManager.session,
                plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]) :
            
            //MARK: - (0-2) Token 없는 경우 -> Interceptor Session 미적용
            MoyaProvider<MementoAPI>(
                plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
            
            provider.request(api) { result in
                
                switch result {
                case .success(let response):
                    
                    //MARK: - (1-1) 요청 성공 & Multipart -> 응답 코드
                    if apiType == .multipart {
                        return single(.success(.statusCode(response.statusCode)))
                    }
                    
                    let decoder = JSONDecoder()
                    
                    //MARK: - (1-2) 요청 성공 & JSON 디코딩 성공 -> 디코딩 한 데이터
                    do {
                        let decodedData = try decoder.decode(T.self, from: response.data)
                        single(.success(.suceessData(decodedData)))
                    } catch {
                        //MARK: - (2-1) 요청 성공 & 디코딩 실패 -> 응답 코드
                        single(.success(.statusCode(response.statusCode)))
                    }
                case .failure(let error):
                    guard let statusCode = error.response?.statusCode
                    else {
                        //MARK: - (2-2) 요청 실패 & 응답 코드가 없을 때 -> 응답 코드 (서버 오류)
                        single(.success(.statusCode(NetworkError.internalServerError.rawValue)))
                        return
                    }
                    //MARK: - (2-3) 요청 실패 & 응답 코드가 있을 때-> 응답 코드
                    single(.success(.statusCode(statusCode)))
                }
            }
            return Disposables.create()
        }
    }
    
    //MARK: - Refresh Access Token
    func refresh(
        accessToken: String,
        refreshToken: String,
        completion: @escaping ( APIResult<RefreshTokenResponseDTO> ) -> Void
    ) {
        let provider = MoyaProvider<MementoAPI>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        
        provider.request(.refreshToken) { result in
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
}
