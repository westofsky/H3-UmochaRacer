//
//  MultiOptionCardButtonViewController.swift
//  iOS_H3
//
//  Created by  sangyeon on 2023/08/09.
//

import UIKit

final class MultiOptionCardButtonViewController: UIViewController {

    enum Constants {
        static let inset = 16.0
        static let cardButtonViewHeight = 168.0
    }

    // MARK: - UI properties

    private lazy var selfModeMultiOptionCardButtonView: MultiOptionCardButtonView = {
        let view = MultiOptionCardButtonView(carMakingMode: .selfMode, step: .powertrain)
        view.configure(with: self.cardInfos, step: .powertrain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var guideModeMultiOptionCardButtonView: MultiOptionCardButtonView = {
        let view = MultiOptionCardButtonView(carMakingMode: .guideMode, step: .powertrain)
        view.configure(with: self.cardInfos, step: .powertrain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    var cardInfos: [OptionCardInfo] = CarMakingContentMockData.mockOption[0]

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDelegate()
        setupViews()
    }

    // MARK: - Helpers

    private func setupDelegate() {
        selfModeMultiOptionCardButtonView.delegate = self
    }

    private func setupViews() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(selfModeMultiOptionCardButtonView)
        view.addSubview(guideModeMultiOptionCardButtonView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            selfModeMultiOptionCardButtonView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 10
            ),
            selfModeMultiOptionCardButtonView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.inset
            ),
            selfModeMultiOptionCardButtonView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.inset
            ),
            selfModeMultiOptionCardButtonView.heightAnchor.constraint(equalToConstant: Constants.cardButtonViewHeight)
        ])
        NSLayoutConstraint.activate([
            guideModeMultiOptionCardButtonView.topAnchor.constraint(
                equalTo: selfModeMultiOptionCardButtonView.bottomAnchor,
                constant: 10
            ),
            guideModeMultiOptionCardButtonView.leadingAnchor.constraint(
                equalTo: selfModeMultiOptionCardButtonView.leadingAnchor
            ),
            guideModeMultiOptionCardButtonView.trailingAnchor.constraint(
                equalTo: selfModeMultiOptionCardButtonView.trailingAnchor
            ),
            guideModeMultiOptionCardButtonView.heightAnchor.constraint(
                equalTo: selfModeMultiOptionCardButtonView.heightAnchor
            )
        ])
    }
}

// MARK: - OptionCardButtonListView Delegate

extension MultiOptionCardButtonViewController: OptionCardButtonListViewDelegate {

    func optionCardButtonListView(
        _ optionCardButtonListView: OptionCardButtonListViewable,
        didSelectOptionAt index: Int
    ) {
        cardInfos[index].isSelected.toggle()
        selfModeMultiOptionCardButtonView.configure(with: cardInfos, step: .powertrain)
    }

    func optionCardButtonListView(
        _ optionCardButtonListView: OptionCardButtonListViewable,
        didDisplayOptionAt index: Int
    ) {

    }
}
