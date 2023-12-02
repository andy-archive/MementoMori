//
//  ResultDecodedFromJSON.swift
//  MementoMori
//
//  Created by Taekwon Lee on 11/30/23.
//

import Foundation

enum APIResult<T> {
    case suceessData(T)
    case errorStatusCode(Int)
}
