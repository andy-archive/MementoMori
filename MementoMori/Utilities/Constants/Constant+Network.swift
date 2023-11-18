//
//  Constant+Network.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/18.
//

import Foundation

extension Constant {
    
    enum NetworkResponse {
        
        enum EmailValidation {
            
            enum Message {
                static let validEmail = "사용 가능한 이메일입니다."
                static let notRequired = "필수값을 채워주세요."
                static let notValidEmail = "사용이 불가한 이메일입니다."
            }
        }
    }
}
