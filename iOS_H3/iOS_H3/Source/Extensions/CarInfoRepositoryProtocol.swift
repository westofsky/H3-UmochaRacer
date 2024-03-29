//
//  CarInfoRepositoryProtocol.swift
//  iOS_H3
//
//  Created by KoJeongMin  on 2023/08/15.
//

import Foundation
import Combine

enum CarInfoRepositoryError: LocalizedError {
    case networkError(Error)
    case conversionError(Error)
    case notExistCommentEndpoint(step: CarMakingStep)

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "[CarInfoRepositoryError] 네트워크 오류: \(error.localizedDescription)"
        case .conversionError(let error):
            return "[CarInfoRepositoryError] 변환 오류: \(error.localizedDescription)"
        case .notExistCommentEndpoint(let step):
            return "[CarInfoRepositoryError] \(step.title) 단계에 대한 CommentEndpoint가 존재하지 않습니다."
        }
    }
}

protocol CarInfoRepositoryProtocol {
    typealias APIResult<T> = AnyPublisher<Result<T, Error>, Never>
    func fetchPowertrain(model: String, type: String) -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchDrivingSystem() -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchBodyType() -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchExteriorColor() -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchInteriorColor() -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchWheel() -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchAdditionalOption(
        category: OptionCategoryType
    ) -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchSingleExteriorColor(optionId: Int) -> AnyPublisher<CarMakingStepInfoEntity, CarInfoRepositoryError>

    func fetchFeedbackComment(step: CarMakingStep, optionID: Int) -> AnyPublisher<FeedbackCommentEntity, Error>
}
