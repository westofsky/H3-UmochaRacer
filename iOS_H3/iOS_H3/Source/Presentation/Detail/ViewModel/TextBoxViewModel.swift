//
//  TextBoxViewModel.swift
//  iOS_H3
//
//  Created by KoJeongMin  on 2023/08/23.
//

import Combine

final class TextBoxViewModel {

    private let detailedOptionUsecase: DictionaryUsecaseProtocol
    // MARK: - Input
    struct Input {
        var viewDidLoad: PassthroughSubject<String, Never>
    }

    // MARK: - Output
    struct Output {
        var title = CurrentValueSubject<String, Never>("")
        var description = CurrentValueSubject<String, Never>("")
    }

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycles
    init(usecase: DictionaryUsecaseProtocol) {
        self.detailedOptionUsecase = usecase
    }

    // MARK: - Helpers

    func transform(input: Input) -> Output {
        let output = Output()

        input.viewDidLoad
            .flatMap { [weak self] targetString -> AnyPublisher<String, Never> in
                guard let self = self else {
                    return Just("").eraseToAnyPublisher()
                }
                return self.detailedOptionUsecase.fetchDictionaryDescription(for: targetString)
                    .catch { error -> Just<String> in
                        return Just(error.localizedDescription)
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { result in
                output.description.send(result)
            }).store(in: &cancellables)
        return output
    }
}
