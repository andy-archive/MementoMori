//
//  ReusableError.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/29/23.
//

import Foundation

protocol ReusableError: Error {
    var rawValue: Int { get }
    var message: String { get }
}
