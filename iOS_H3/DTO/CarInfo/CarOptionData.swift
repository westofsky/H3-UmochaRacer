//
//  CarOptionData.swift
//  iOS_H3
//
//  Created by KoJeongMin  on 2023/08/18.
//

import Foundation

enum CarOptionToEntityError: LocalizedError {
    case missingID
    case missingName
    case missingTitle

    var errorDescription: String? {
        switch self {
        case .missingID:
            return "ID 값이 없습니다."
        case .missingName:
            return "이름 값이 없습니다."
        case .missingTitle:
            return "제목 값이 없습니다."

        }
    }
}

struct CarOptionData: Decodable {
    let id: Int?
    let name: String?
    let label: String?
    let price: Int?
    let imageSrc: String?
    let iconSrc: String?
    let colorCode: String?
    let parts: String?
    let partsSrc: String?
}

extension CarOptionData {
    func toDomain() throws -> OptionCardInfoEntity {

        guard let id = self.id else {
            throw CarOptionToEntityError.missingID
        }

        guard let name = self.name else {
            throw CarOptionToEntityError.missingName
        }

        let bannerImageURL = URL(string: self.imageSrc ?? "")!
        let iconImageURL = URL(string: self.iconSrc ?? "")
        let color = URL(string: self.colorCode ?? "")

        return OptionCardInfoEntity(
            id: id,
            title: name,
            subTitle: self.label ?? "",
            priceString: String.priceStringWithPlus(from: price ?? 0),
            bannerImageURL: bannerImageURL,
            iconImageURL: iconImageURL,
            color: color,
            hasMoreInfo: false
        )
    }
}
