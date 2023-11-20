//
//  String+.swift
//  MementoMori
//
//  Created by Taekwon Lee on 2023/11/20.
//

import Foundation

extension String {
    func validateEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,50}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: self)
        
        return isValid ? true : false
    }
}
