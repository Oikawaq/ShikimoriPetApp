//
//  NetworkErorr.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 1/6/26.
//

import Foundation

public enum NetworkError: Error {
    case badUrl
    case badResponse
    case badData
    case failedToOpenSafari
    case unauthorized
}
