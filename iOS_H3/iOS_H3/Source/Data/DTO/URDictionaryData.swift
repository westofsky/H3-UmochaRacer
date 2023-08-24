//
//  DictionaryData.swift
//  iOS_H3
//
//  Created by  sangyeon on 2023/08/24.
//

import Foundation

enum URDictionaryDataToEntityError: LocalizedError {
    case missingKeyword
    case missingDescription

    var errorDescription: String? {
        switch self {
        case .missingKeyword:
            return "키워드가 존재하지 않습니다."
        case .missingDescription:
            return "키워드에 대한 설명이 존재하지 않습니다."
        }
    }
}

struct URDictionaryData: Decodable {
    let keyword: String?
    let description: String?
    let imageSrc: String?
}
