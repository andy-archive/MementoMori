//
//  RefreshInterceptor.swift
//  MementoMori
//
//  Created by Taekwon Lee on 12/10/23.
//

import Foundation

import Alamofire
import Moya

final class RefreshInterceptor: RequestInterceptor {
    
    //MARK: - Singleton
    static let shared = RefreshInterceptor(
        keychainRepository: KeychainRepository()
    )
    
    //MARK: - Repository
    private let keychainRepository: KeychainRepositoryProtocol
    
    //MARK: - Initializer
    private init(
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.keychainRepository = keychainRepository
    }
    
    //MARK: - adapt (RequestInterceptor)
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        let keychain = findToken()
        
        guard let accessToken = keychain.accessToken,
              let refreshToken = keychain.refreshToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: MementoAPI.HTTPHeaderField.accessToken)
        urlRequest.setValue(refreshToken, forHTTPHeaderField: MementoAPI.HTTPHeaderField.refreshToken)
        urlRequest.setValue(MementoAPI.secretKey, forHTTPHeaderField: MementoAPI.HTTPHeaderField.secretKey)
        
        completion(.success(urlRequest))
    }
    
    //MARK: - retry (RequestInterceptor)
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        let keychain = findToken()
        
        guard let statusCode = request.response?.statusCode, statusCode == 419,
              let accessToken = keychain.accessToken,
              let refreshToken = keychain.refreshToken
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        APIManager.shared.refresh(
            accessToken: accessToken,
            refreshToken: refreshToken
        ) { result in
            switch result {
                //MARK: - 결과 (1) 액세스 토큰 갱신
            case .suceessData(let data):
                self.saveToken(data.accessToken)
                completion(.retry)
                //MARK: - 결과 (2) 리프래시 토큰 만료
            case .statusCode(_):
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    //MARK: - findToken
    func findToken() -> (accessToken: String?, refreshToken: String?) {
        guard let userID = keychainRepository.find(key: "", type: .userID)
        else { return (nil, nil) }
        
        let accessToken = keychainRepository.find(key: userID, type: .accessToken)
        let refreshToken = keychainRepository.find(key: userID, type: .refreshToken)
        
        return (accessToken, refreshToken)
    }
    
    //MARK: - saveToken
    func saveToken(_ accessToken: String?) {
        guard let accessToken,
              let userID = keychainRepository.find(key: "", type: .userID),
              keychainRepository.save(key: userID, value: accessToken, type: .accessToken)
        else { return }
    }
}
