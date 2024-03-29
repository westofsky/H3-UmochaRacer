//
//  CarMakingOptionSelectStepCell.swift
//  iOS_H3_UI
//
//  Created by  sangyeon on 2023/08/18.
//

import UIKit
import Combine

final class CarMakingOptionSelectStepCell: CarMakingCollectionViewCell {

    static let identifier = "CarMakingOptionSelectStepCell"

    enum Constants {
        static let prefixOfOptionCountLabel = "선택 옵션"
        static let selectedOptionCountLabelLeadingOffset = 12.0
        static let listModeButtonTrailingOffset = 16.0
        static let listModeWidth = 20.0
        static let listModeHeight = 20.0
        static let categoryTabBarTopOffset = 8.0
        static let categoryTabBarHeight = 32.0
    }

    // MARK: - UI properties

    private let selectedOptionCountLabel = UILabel()

    private let listModeButton = UIButton()

    private let listModeView = OptionListModeView(carMakingMode: .selfMode, step: .powertrain)

    private let categoryTabBar = OptionCategoryTabBar()

    // MARK: - Properties

    private var currentOptionInfo = [OptionCardInfo]()
    private var step: CarMakingStep = .powertrain

    var optionCategoryTapSubject = PassthroughSubject<OptionCategoryType, Never>()

    // MARK: - Lifecycles

    override init(frame: CGRect) {
        super.init(frame: frame, buttonListViewable: MultiOptionCardButtonView.init())

        setupProperties()
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupProperties()
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        listModeView.isHidden = true
        currentOptionInfo = []
        optionCategoryTapSubject = PassthroughSubject<OptionCategoryType, Never>()
    }

    // MARK: - Helpers

    override func configure(optionInfoArray: [OptionCardInfo], step: CarMakingStep) {
        super.configure(optionInfoArray: optionInfoArray, step: step)
        listModeView.configure(with: optionInfoArray, step: step)
        currentOptionInfo = optionInfoArray
        self.step = step
        if !optionInfoArray.isEmpty {
            guard let listView = optionButtonListView as? MultiOptionCardButtonView else { return }
            listView.showFirstOptionCard()
        }
    }

    override func update(optionInfoArray: [OptionCardInfo], step: CarMakingStep) {
        self.step = step
        super.update(optionInfoArray: optionInfoArray, step: step)
        listModeView.reloadOptionCards(with: optionInfoArray, step: step)
        currentOptionInfo = optionInfoArray
    }

    override func playFeedbackAnimation(with feedbackComment: FeedbackComment, completion: (() -> Void)? = nil) {
        super.playFeedbackAnimation(with: feedbackComment, completion: completion)
        listModeView.playFeedbackAnimation(with: feedbackComment)
    }

    func updateSelectedOptionCountLabel(to count: Int) {
        selectedOptionCountLabel.text = "\(Constants.prefixOfOptionCountLabel) \(count)"
    }

    private func showListModeView(isHidden: Bool, step: CarMakingStep) {
        if isHidden {
            super.configure(optionInfoArray: currentOptionInfo, step: step)
        }
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.listModeView.isHidden = isHidden
        })
    }
}

// MARK: - OptionListModeView Delegate

extension CarMakingOptionSelectStepCell: OptionListModeViewDelegate {
    func optionListModeViewDidTapImageModeButton(with optionListModeView: OptionListModeView) {
        showListModeView(isHidden: true, step: self.step)
    }
}

// MARK: - OptionCategoryTabBar Delegate

extension CarMakingOptionSelectStepCell: OptionCategoryTabBarDelegate {
    func tabBarButtonDidTapped(didSelectItemAt index: Int) {
        guard let category = OptionCategoryType(rawValue: index) else {
            return
        }
        optionCategoryTapSubject.send(category)
    }
}

// MARK: - Setup

extension CarMakingOptionSelectStepCell {

    private func setupProperties() {
        setupSelectedOptionCountLabel()
        setupListModeButton()
        setupListModeView()
        setupCategoryTabBar()
    }

    private func setupViews() {
        addSubviews()
        setupConstraints()
    }

    private func setupSelectedOptionCountLabel() {
        selectedOptionCountLabel.text = "\(Constants.prefixOfOptionCountLabel) 0"
        selectedOptionCountLabel.font = Fonts.regularBody3
        selectedOptionCountLabel.textColor = Colors.subActiveBlue
        selectedOptionCountLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupListModeButton() {
        listModeButton.setImage(UIImage(named: "list_mode_button"), for: .normal)
        listModeButton.tintColor = .black
        listModeButton.addTarget(self, action: #selector(listModeButtonDidTap), for: .touchUpInside)
        listModeButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupListModeView() {
        listModeView.translatesAutoresizingMaskIntoConstraints = false
        listModeView.isHidden = true
        listModeView.backgroundColor = .white
        listModeView.delegate = self
        listModeView.listModeViewDelegate = self
    }

    private func setupCategoryTabBar() {
        categoryTabBar.translatesAutoresizingMaskIntoConstraints = false
        categoryTabBar.tabBarDelegate = self
    }

    @objc
    private func listModeButtonDidTap() {
        showListModeView(isHidden: false, step: self.step)
    }

    private func addSubviews() {
        [selectedOptionCountLabel, listModeButton, listModeView, categoryTabBar]
            .forEach {
                contentView.addSubview($0)
            }
    }

    private func setupConstraints() {
        setupSelectedOptionCountLabelConstraints()
        setupListModeButtonConstraints()
        setupListModeViewConstraints()
        setupCategoryTabBarConstraints()
    }

    private func setupSelectedOptionCountLabelConstraints() {
        NSLayoutConstraint.activate([
            selectedOptionCountLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            selectedOptionCountLabel.leadingAnchor.constraint(
                equalTo: descriptionLabel.trailingAnchor,
                constant: Constants.selectedOptionCountLabelLeadingOffset
            )
        ])
    }

    private func setupListModeButtonConstraints() {
        NSLayoutConstraint.activate([
            listModeButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            listModeButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.listModeButtonTrailingOffset
            ),
            listModeButton.widthAnchor.constraint(equalToConstant: Constants.listModeWidth),
            listModeButton.heightAnchor.constraint(equalToConstant: Constants.listModeHeight)
        ])
    }

    private func setupListModeViewConstraints() {
        NSLayoutConstraint.activate([
            listModeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listModeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listModeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listModeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupCategoryTabBarConstraints() {
        NSLayoutConstraint.activate([
            categoryTabBar.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.categoryTabBarTopOffset
            ),
            categoryTabBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryTabBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryTabBar.heightAnchor.constraint(equalToConstant: Constants.categoryTabBarHeight)
        ])
    }
}
