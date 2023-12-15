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
    
    //MARK: - Properties
    private let keychain = KeychainRepository.shared
    
    //MARK: - Singleton
    static let shared = RefreshInterceptor()
    
    private init() { }
    
    //MARK: - Protocol Functions
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        guard
            let userID = keychain.find(key: "", type: .userID),
            let accessToken = keychain.find(key: userID, type: .accessToken),
            let refreshToken = keychain.find(key: userID, type: .refreshToken)
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
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard
            let userID = keychain.find(key: "", type: .userID),
            let accessToken = keychain.find(key: userID, type: .accessToken),
            let refreshToken = keychain.find(key: userID, type: .refreshToken),
            let statusCode = request.response?.statusCode, statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        APIManager.shared.refresh(
            accessToken: accessToken,
            refreshToken: refreshToken
        ) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
                
            //MARK: - Access Token Updated
            case .suceessData(let data):
                if self.keychain.save(key: userID, value: data.accessToken, type: .accessToken) {
                    completion(.retry)
                }
                
            //MARK: - Refresh Token EXPIRED
            case .statusCode(_):
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
